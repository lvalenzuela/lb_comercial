class SiteController < ApplicationController
	require "json"
	require "uri"
	require "bcrypt"

	def index
		@types = CourseType.all()
		@modes = Course.select("distinct(mode) as mode")
	end

	def available_courses
		if params[:date] && params[:mode]
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
		if current_user
			@courses_for_date = Course.where("MONTH(start_date) = #{session[:selected_month]} and mode = '#{session[:selected_mode]}' and course_level_id = #{current_user.course_level_id}")
			@course_features = CourseFeature.where(:course_id => @courses_for_date.map{|c| c.id})
		else
			@courses_for_date = nil
			@course_features = nil
		end
	end

	def signup
		@web_user = WebUser.new()
	end

	def organization_signup
		@lead = ZohoLead.new()
	end

	def edit_user
		@user = current_user
	end

	def confirm_purchase
		if params[:course_id]
			session[:selected_course] = params[:course_id]
		end
		@user = current_user
		@course = Course.find(session[:selected_course])
		@course_features = CourseFeature.where(:course_id => @course.id)
	end


	def register_purchase
		cm = CourseMember.where(:course_id => session[:selected_course], :web_user_id => current_user.id)
		if cm.blank?
			#si el alumno no se encuentra en el curso, registrarlo
			user = current_user
			#Registrar el contacto en zoho para realizar la compra
			contact_response = enable_zoho_contact(user)
			if contact_response["code"].to_i == 0
				#El contacto fue registrado en zoho, se procede a registrar la compra
				@course = Course.find(session[:selected_course])
				@user = current_user
				@course_features = CourseFeature.where(:course_id => @course.id)
				invoice_response = register_invoice(@user,@course)
				if invoice_response["code"].to_i == 0
					register_course_member(@user,@course)
					flash[:notice] = "La compra fue realizada con exito"
				else
					flash[:notice] = "Ocurrió un error al registrar la compra. Error: "+invoice_response["message"]
				end
			else
				@course = Course.find(session[:selected_course])
				@user = current_user
				@course_features = CourseFeature.where(:course_id => @course.id)
				flash[:notice] = "Ocurrió un error al registrar el usuario en el sistema. Error: ["+contact_response["code"].to_s+"] "+contact_response["message"]
			end
		else
			#No se puede realizar la compra, el alumno ya esta registrado en el curso
			@course = Course.find(session[:selected_course])
			@user = current_user
			@course_features = CourseFeature.where(:course_id => @course.id)
			flash[:notice] = "La compra no se ha realizado. El alumno ya pertenece al curso seleccionado."
		end
	end

	def successful_registration

	end

	def play_tha_game

	end

	def test_results
		@user = current_user
		if @user
			@user.test_score = params[:results]
			@user.save!
			redirect_to :action => :available_courses
		else
			session[:test_score] = params[:results]
			redirect_to :action => :available_courses
		end
	end

#####################################
#Funciones privadas para esta clase
#####################################
	private

	def enable_zoho_contact(web_user)
		if !web_user.zoho_enabled
			response = post_data("contacts", format_user_for_contact_post(web_user))
			if response["code"].to_i == 0
				update_web_user_data(web_user,response["contact"])
			end
			return response
		else
			#el contacto esta registrado en zoho
			#se retorna código de exito
			return {"code" => 0}
		end
	end

	def update_web_user_data(web_user,contact_array)
		web_user.update_attributes(:zoho_contact_id => contact_array["contact_id"], :zoho_contact_person_id => contact_array["contact_persons"].first()["contact_person_id"], :zoho_enabled => true)
	end

	def format_user_for_contact_post(web_user)
		contact_person_array = [{
			:salutation => define_salutation(web_user.gender),
			:first_name => web_user.firstname,
			:lastname => web_user.lastname,
			:email => web_user.email,
			:phone => web_user.phone,
			:mobile => web_user.mobile,
			:is_primary_contact => "true"
			}]

		contact = {
			:contact_name => web_user.name+" ["+web_user.email+"]",
			:billing_address => {
				:address => web_user.location
			},
			:contact_persons => contact_person_array
		}
		return contact
	end

	def define_salutation(gender)
		if gender == "male"
			return "Sr."
		else
			return "Srta."
		end
	end

	def register_invoice(web_user,course)
		item_response = get_data_from_zoho("items",course.zoho_product_id)
		if item_response["code"].to_i == 0
			response = post_data("invoices",format_invoice_for_post(web_user,item_response["item"]))
			if response["code"].to_i == 0
				register_local_invoice(web_user.id,response["invoice"])
				mail_response = mark_invoice_as_sent(response["invoice"]["invoice_id"])
			end
		else
			return item_response
		end
		return response
	end

	def register_course_member(user,course)
		cm = CourseMember.create(:course_id => course.id, :web_user_id => user.id)
		if cm.valid?
			return true
		else
			return false
		end
	end

	def mail_invoice_to_customer(zoho_invoice_id)
		return post_data("invoices/"+zoho_invoice_id+"/email",nil)
	end

	def mark_invouce_as_sent(zoho_invoice_id)
		return post_data("invoices/"+zoho_invoice_id+"/status/sent",nil)
	end

	def register_local_invoice(web_user_id,invoice_response)
		invoice = ZohoInvoice.create(:customer_id => web_user_id, :zoho_contact_id => invoice_response["customer_id"], :zoho_invoice_id => invoice_response["invoice_id"])
		if invoice.valid?
			return true
		else
			return false
		end
	end

	def format_invoice_for_post(customer,product)

		invoice = {
			:customer_id => customer.zoho_contact_id,
			:contact_persons => [customer.zoho_contact_person_id],
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
