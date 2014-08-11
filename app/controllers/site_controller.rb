class SiteController < ApplicationController
	require "json"
	require "uri"
	require "bcrypt"

	def index
		@types = CourseType.all()
		@modes = Course.select("distinct(mode) as mode")
	end

	def available_courses
		if params[:date][:month] && params[:mode]
			session[:selected_month] = params[:date][:month]
			session[:selected_mode] = params[:mode]
		end
		@selected_month = session[:selected_month]
		@selected_mode = session[:selected_mode]

		raw_products = zoho_product_list
		if raw_products["code"] == 0
			@modes = raw_products["items"].uniq{|i| i["name"]}
		else
			@modes = nil
		end
		@courses = Course.where("MONTH(start_date) BETWEEN (#{session[:selected_month]}-2) AND (#{session[:selected_mode]}+2)")
	end

	def load_extra_content
		@courses = Course.where("MONTH(start_date) = #{params[:month]} and mode = '#{params[:mode]}'")
		@course_features = CourseFeature.where(:course_id => @courses.map{|c| c.id})
		respond_to do |format|
			format.js
		end
	end

	def new_contact_person
		if current_user.nil?
			redirect_to :action => :login
		else
			@contact_person = ContactPerson.new()
		end
	end

	def edit_contact
		current_contact_id = current_user.contact_id
		if params[:contact_id].to_i != current_contact_id
			#si se selecciona modificar a un usuario que no corresponde
			#se redirige a confirm_purchase
			flash[:notice] = "No se puede modificar este usuario"
			redirect_to :action => :confirm_purchase
		else
			@contact_person = ContactPerson.find(params[:cp_id])
			@contact_people = ContactPerson.where(:contact_id => current_contact_id)
		end
	end

	def contact_signup
		@contact_person = ContactPerson.new()
	end

	def organization_signup
		@lead = ZohoLead.new()
	end

	def confirm_purchase
		if params[:course_id]
			session[:selected_course] = params[:course_id]
		end
		@contact = Contact.find(current_user.contact_id)
		@contact_people = ContactPerson.where(:contact_id => @contact.id)
		@primary_contact = ContactPerson.find(current_user.id)
		@course = Course.find(session[:selected_course])
		@course_features = CourseFeature.where(:course_id => @course.id)
	end

	def register_purchase
		#Verificar si el alumno ya se encuentra en ese curso
		cm = CourseMember.where(:course_id => session[:selected_course], :contact_person_id => params[:selected_student])
		if cm.blank?
			#registrar contacto en zoho si no esta registrado
			contact = Contact.find(current_user.contact_id)
			##Revisa si el contacto esta registrado en zoho junto con todas las personas que involucra
			##Aquellos que no estan registrados, los registra
			contact_response = enable_zoho_contact(contact)
			if contact_response["code"].to_i == 0
				#Se recupera nuevamente el contacto con la informacion actualizada
				@contact = Contact.find(contact.id)
				@course = Course.find(session[:selected_course])
				@course_features = CourseFeature.where(:course_id => @course.id)
				@contact_person = ContactPerson.find(params[:selected_student])
				response = register_invoice(@contact,@course)
				if response["code"].to_i == 0
					register_course_member(@course,params[:selected_student])
					flash[:notice] = "La compra fue realizada con exito"
				else
					flash[:notice] = "Ocurrió un error al registrar la compra. Error: "+response["message"]
				end
			else
				@contact = Contact.find(contact.id)
				@course = Course.find(session[:selected_course])
				@course_features = CourseFeature.where(:course_id => @course.id)
				@contact_person = ContactPerson.find(params[:selected_student])
				#hubo un error registrando al contacto en zoho
				flash[:notice] = "Ocurrió un error al registrar el usuario en el sistema. Error: ["+contact_response["code"].to_s+"] "+contact_response["message"]
			end
		else
			@contact = Contact.find(current_user.contact_id)
			@course = Course.find(session[:selected_course])
			@course_features = CourseFeature.where(:course_id => @course.id)
			@contact_person = ContactPerson.find(params[:selected_student])
			flash[:notice] = "La compra no se ha realizado. El alumno ya pertenece al curso seleccionado."
		end
	end

	def successful_registration

	end

	def play_tha_game

	end

	def test_results
		session[:user_test_results] = params[:results]
	end

#####################################
#Funciones privadas para esta clase
#####################################
	private

	def enable_zoho_contact(contact)
		if !contact.zoho_enabled
			#contacto no registrado
			#se registra y se registran sus sub contactos tambien
			contact_people = ContactPerson.where(:contact_id => contact.id)
			#registro en zoho
			response = post_data("contacts",format_contact_for_post(contact,contact_people))
			#registro local de las correspondientes ID de los contactos en zoho
			if response["code"].to_i == 0
				update_local_contact_data(contact,response["contact"])
			end
			return response
		else
			#el contacto esta registrado en zoho.
			#se revisa si todos los subcontactos estan registrados
			contact_people = ContactPerson.where(:contact_id => contact.id, :zoho_enabled => false)
			if contact_people.blank? || contact_people.nil?
				#todos los sub_contactos del contacto estan registrados en zoho
				return {"code" => 0}
			else
				contact_people.each do |cp|
					response = post_data("contacts/contactpersons",format_contact_person_for_post(contact,cp))
					if response["code"].to_i != 0
						#si en algun caso hay un error, retornar
						return response
					else
						#actualizar datos locales con los datos de la ID de zoho
						cp.update_attributes(:zoho_contact_person_id => response["contact_person"]["contact_person_id"], :zoho_enabled => true)
					end
				end
				return {"code" => 0}
			end
		end
	end

	def update_local_contact_data(local_contact,updated_contact)
		local_contact.update_attributes(:zoho_enabled => true, :zoho_contact_id => updated_contact["contact_id"])
		updated_contact["contact_persons"].each do |c|
			cp = ContactPerson.where(:email => c["email"]).first()
			cp.update_attributes(:zoho_enabled => true, :zoho_contact_person_id => c["contact_person_id"])
		end
	end

	def register_invoice(contact,course)
		item_response = get_data_from_zoho("items",course.zoho_product_id)
		if item_response["code"].to_i == 0
			response = post_data("invoices",format_invoice_for_post(contact,item_response["item"]))
			if response["code"].to_i == 0
				register_local_invoice(@contact.id,response["invoice"])
				mail_response = mail_invoice_to_customer(response["invoice"]["invoice_id"])
			end
		else
			return item_response
		end
		return response
	end

	def register_course_member(course,contact_person_id)
		cm = CourseMember.create(:course_id => course.id, :contact_person_id => contact_person_id)
		if cm.valid?
			return true
		else
			return false
		end
	end

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

	def format_contact_person_for_post(contact,contact_person)
		#agrega sub_contactos a zoho bajo el contacto señalado
		contact_person = {
			:contact_id => contact.zoho_contact_id,
			:salutation => contact_person.salutation,
			:first_name => contact_person.firstname,
			:last_name => contact_person.lastname,
			:email => contact_person.email,
			:phone => contact_person.phone,
			:mobile => contact_person.mobile
		}
		return contact_person
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
		data = get_zoho_data("Longbourn","invoice")
		uri = URI.parse("https://invoice.zoho.com/api/v3/"+post_type)
		if array
			resp = Net::HTTP.post_form(uri, {"authtoken" => data.authtoken, "organization_id" => data.organization_id,"JSONString" => array.to_json})
		else
			resp = Net::HTTP.post_form(uri, {"authtoken" => data.authtoken, "organization_id" => data.organization_id})
		end
		return JSON.parse resp.body
	end

	def get_data_from_zoho(data_type,data_id)
		data = get_zoho_data("Longbourn","invoice")
		url = "https://invoice.zoho.com/api/v3/"+data_type+"/"+data_id+"?authtoken="+data.authtoken+"&organization_id="+data.organization_id
		resp = Net::HTTP.get_response(URI.parse(url))
		return JSON.parse resp.body
	end

    def zoho_product_list
    	data = get_zoho_data("Longbourn","invoice")
    	url = "https://invoice.zoho.com/api/v3/items?authtoken="+data.authtoken+"&organization_id="+data.organization_id
    	resp = Net::HTTP.get_response(URI.parse(url))
    	return JSON.parse resp.body
    end

    def get_zoho_data(organization,service)
    	return ZohoOrganizationData.where(:organization_name => organization, :service => service).first()
    end
end
