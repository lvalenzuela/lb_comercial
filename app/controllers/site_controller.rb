class SiteController < ApplicationController
	require "json"
	require "uri"
	require "bcrypt"

	def index
		@types = CourseType.all()
	end

	def available_courses
		raw_products = zoho_product_list
		if raw_products["code"] == 0
			@modes = raw_products["items"].uniq{|i| i["name"]}
		else
			@modes = nil
		end
		@courses = Course.where("MONTH(start_date) BETWEEN (#{params[:date][:month]}-2) AND (#{params[:date][:month]}+2)")
		@selected_month = params[:date][:month]
	end

	def load_extra_content
		@courses = Course.where("MONTH(start_date) = #{params[:month]} and mode = '#{params[:mode]}'")
		@course_features = CourseFeature.where(:course_id => @courses.map{|c| c.id})
		respond_to do |format|
			format.js
		end
	end

	def client_registration
		@course = Course.find(params[:course_id])
		@course_features = CourseFeature.where(:course_id => @course.id)
	end
	
	def client_login
		contact_person = ContactPerson.where(:email => params[:email]).first()
		if contact_person.blank? || contact_person.nil?
			flash[:notice] = "Datos de usuario incorrectos."
			redirect_to :action => :client_registration, :course_id => params[:course_id]
		else
			password = BCrypt::Password.new(contact_person.password)
			if password == params[:password]
				contact = Contact.find(contact_person.contact_id)
				session[:contact_id] = contact.id
				session[:contact_person_id] = contact_person.id
				redirect_to :action => :confirm_purchase, :course_id => params[:course_id]
			else
				flash[:notice] = "Contraseña Incorrecta"
				redirect_to :action => :client_registration, :course_id => params[:course_id]
			end
		end
	end

	def register_local
		@contact = Contact.create(	:contact_name => params[:email],
									:rut => params[:rut],
									:address => params[:address],
									:city => params[:city],
									:phone => params[:phone]
									)
		if @contact.valid?
			@contact_person = ContactPerson.create(	:contact_id => @contact.id,
													:gender => params[:gender],
													:birthday => params[:birthday],
													:firstname => params[:firstname],
													:lastname => params[:lastname],
													:rut => params[:rut],
													:password => params[:password],
													:password_confirmation => params[:password_confirmation],
													:email => params[:email],
													:phone => params[:phone],
													:mobile => params[:mobile],
													:is_primary_contact => true,
													)
			if @contact.valid?
				session[:contact_id] = @contact.id
				session[:contact_person_id] = @contact_person.id
				redirect_to :action => :confirm_purchase, :course_id => params[:course_id]
			else
				@course = Course.find(params[:course_id])
				flash[:notice] = "Error al registrar nuevo contacto."
				render :client_registration
			end
		else
			@course = Course.find(params[:course_id])
			flash[:notice] = "Error al registrar nuevo contacto."
			render :client_registration
		end
	end

	def confirm_purchase
		@contact = Contact.find(session[:contact_id])
		@contact_person = ContactPerson.find(session[:contact_person_id])
		@course = Course.find(params[:course_id])
		@course_features = CourseFeature.where(:course_id => @course.id)
	end

	def register_purchase
		@contact = Contact.find(session[:contact_id])
		@contact_people = ContactPerson.where(:contact_id => @contact.id)
		@course = Course.find(params[:course_id])
		if @contact.zoho_enabled
			flash[:notice] = "El cliente ya se encuentra registrado en zoho."
		else
			response = post_data("contacts",format_contact_for_post(@contact,@contact_people))
			case response["code"].to_i
			when 0
				update_local_contact_data(@contact,response["contact"])
				flash[:notice] = "El cliente ha sido registrado exitosamente"
			when 1001
				flash[:notice] = "Ya existe un contacto registrado con ese nombre"
			else
				flash[:notice] = "Se presentó un problema con su registro. Error: "+response["message"]
			end
		end
	end

	def register_invoice
		@contact = Contact.find(session[:contact_id])
		@course = Course.find(params[:course])
		@course_features = CourseFeature.where(:course_id => @course.id)
		item_response = get_data_from_zoho("items",@course.productpriceid)
		if item_response["code"].to_i == 0
			response = post_data("invoices",format_invoice_for_post(@contact,item_response["item"]))
			if response["code"].to_i != 0
				flash[:notice] = "Ocurrio un problema y no se pudo registrar la Factura. Error: "+response["message"]
			else
				if register_local_invoice(@contact.id,response["invoice"])
					mail_response = mail_invoice_to_customer(response["invoice"]["invoice_id"])
					flash[:notice] = "La factura ha sido generada con exito. "+mail_response["message"]
				else
					flash[:notice] = "La factura ha sido registrada, pero hubo un error al registrarla localmente."
				end
			end
		end
	end

#####################################
#Funciones privadas para esta clase
#####################################
	private

	def mail_invoice_to_customer(zoho_invoice_id)
		return post_data("invoices/"+zoho_invoice_id+"/email",nil)
	end

	def register_local_invoice(contact_id,invoice_response)
		invoice = ZohoInvoice.create(:contact_id => contact_id, :zoho_contact_id => invoice_response["customer_id"], :zoho_invoice_id => invoice_response["invoice_id"])
		if invoice.valid?
			return true
		else
			return false
		end
	end

	def format_invoice_for_post(customer,product)
		contact_person = ContactPerson.where(:contact_id => customer.id, :is_primary_contact => true).first()

		invoice = {
			:customer_id => customer.zoho_contact_id,
			:contact_persons => [contact_person.zoho_contact_person_id],
			#:invoice_number => nil,
			#template_id => nil,
			:date => Date.current().strftime("%Y-%m-%d"),
			:payment_terms => 30,
			:payment_terms_label => "Pago a 30 Días",
			:due_date => (Date.current() + 30.days).strftime("%Y-%m-%d"),
			:discount => 0,
			#:is_discount_before_tax => true,
			#:discount_type => "item_level",
			:exchange_rate => 1.00,
			#:recurring_invoice_id => "",
			#:invoiced_estimate_id => "",
			:sales_person_name => "Canal de Ventas Online",
			:line_items => [{
					:item_id => product["item_id"],
					:project_id => "",
					:expense_id => "",
					:name => product["name"],
					:description => product["description"],
					:item_order => 1,
					:rate => product["rate"],
					:unit => "",
					:quantity => 1,
					:discount => 0.00,
					:tax_id => ""
					}
				],
			:allow_partial_payments => true,
			:custom_body => "",
			:custom_subject => "",
			:notes => "Gracias por preferirnos.",
			:terms => "Terms and conditions apply.",
			:shipping_charge => 0.00,
			:adjustment => 0.00,
			:adjustment_description => ""
		}
		return invoice
	end

	def update_local_contact_data(local_contact,updated_contact)
		local_contact.update_attributes(:zoho_enabled => true, :zoho_contact_id => updated_contact["contact_id"])
		updated_contact["contact_persons"].each do |c|
			cp = ContactPerson.where(:email => c["email"]).first()
			cp.update_attributes(:zoho_enabled => true, :zoho_contact_person_id => c["contact_person_id"])
		end
	end

	def format_contact_for_post(contact,contact_people)
		contact_people_array = []
		contact_people.each do |c|
			if c.is_primary_contact
				contact_people_array << {
					:salutation => c.salutation,
					:first_name => c.firstname,
					:last_name => c.lastname,
					:email => c.email,
					:phone => c.phone,
					:mobile => c.mobile,
					:is_primary_contact => "true"
				}
			else
				contact_people_array << {
					:salutation => c.salutation,
					:first_name => c.firstname,
					:last_name => c.lastname,
					:email => c.email,
					:phone => c.phone,
					:mobile => c.mobile,
				}
			end
		end
		contact = {
			:contact_name => contact.contact_name,
			:company_name => contact.company_name,
			#:payment_terms => contact.payment_terms,
			#:payment_terms_label => contact.payment_terms_label,
			#:currency_id => contact.currency_id,
			:website => contact.website,
			:billing_address => {
				:address => contact.address,
				:city => contact.city,
				:country => contact.country
			},
			:shipping_address => {
				:address => contact.address,
				:city => contact.city,
				:country => contact.country
			},
			:contact_persons => contact_people_array,
			:notes => contact.notes
		}
		return contact
	end

	def post_data(post_type,array)
		data = get_zoho_data("Longbourn")
		uri = URI.parse("https://invoice.zoho.com/api/v3/"+post_type)
		if array
			resp = Net::HTTP.post_form(uri, {"authtoken" => data.authtoken, "organization_id" => data.organization_id,"JSONString" => array.to_json})
		else
			resp = Net::HTTP.post_form(uri, {"authtoken" => data.authtoken, "organization_id" => data.organization_id})
		end
		return JSON.parse resp.body
	end

	def get_data_from_zoho(data_type,data_id)
		data = get_zoho_data("Longbourn")
		url = "https://invoice.zoho.com/api/v3/"+data_type+"/"+data_id+"?authtoken="+data.authtoken+"&organization_id="+data.organization_id
		resp = Net::HTTP.get_response(URI.parse(url))
		return JSON.parse resp.body
	end

    def zoho_product_list
    	data = get_zoho_data("Longbourn")
    	url = "https://invoice.zoho.com/api/v3/items?authtoken="+data.authtoken+"&organization_id="+data.organization_id
    	resp = Net::HTTP.get_response(URI.parse(url))
    	return JSON.parse resp.body
    end

    def get_zoho_data(organization)
    	return ZohoOrganizationData.where(:organization_name => organization).first()
    end
end
