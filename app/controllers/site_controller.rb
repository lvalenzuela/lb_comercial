class SiteController < ApplicationController
	require "json"
	require "uri"
	require "bcrypt"

	def index
		@types = CourseType.all()
		raw_products = zoho_product_list
		if raw_products["code"] == 0
			@modes = raw_products["items"]
		else
			@modes = nil
		end
		#@modes = Course.select("distinct(mode) as mode")
		#Se registra el paso
		session[:action_milestone] = action_name
	end

	def contact_us
		
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

	def redirect_view
		@controller = params[:controller_name]
		@action = params[:action_name]
	end

	def show_challenges
		session[:action_milestone] = action_name
	end

	def play_tha_game
		session[:action_milestone] = action_name
		if current_user && current_user.test_score
			redirect_to :action => :available_courses
		end
	end

	def test_results
		if params[:results]
			@user = current_user
			if @user
				@user.test_score = params[:results]
				@user.save!
				redirect_to :action => :available_courses
			else
				session[:test_score] = params[:results]
				flash[:notice] = "Registrate para conocer tu nivel de inglés y los cursos que te corresponden!"
				redirect_to :action => :signup
			end
		else
			flash[:notice] = "No se ha registrado un puntaje para el Quiz de Diagnostico."
			redirect_to :action => session[:action_milestone]
		end
	end

	def available_courses
		session[:action_milestone] = action_name
		@current_date = Time.now
		@modes = CourseMode.where(:enabled => true)
		@courses = Course.where("WEEK(start_date) BETWEEN WEEK('#{@current_date.strftime('%Y-%m-%d')}') AND (WEEK('#{@current_date.strftime('%Y-%m-%d')}')+6) AND course_level_id = #{current_user.course_level_id}")
	end

	def selected_courses_list
		@courses = Course.where("WEEK(start_date) BETWEEN WEEK('#{params[:date]}') AND (WEEK('#{params[:date]}')+1) and mode = #{params[:mode]} and course_level_id = #{current_user.course_level_id}")
		@date = Date.parse(params[:date])
	end

	def course_details_report
		course = Course.find(params[:course_id])
		course_level = CourseLevel.find(course.course_level_id).course_level

		respond_to do |format|
			format.html
			format.pdf do
				pdf = CourseDetailsPdf.new(course,view_context)
				send_data pdf.render, filename: course.coursename+"_"+course_level+"_Details.pdf", type: "application/pdf"
			end
		end
	end

	def confirm_purchase
		if params[:course_id]
			session[:selected_course] = params[:course_id]
		end
		@user = current_user
		@course = Course.find(session[:selected_course])
		@product_features = CourseMode.where(:zoho_product_id => @course.zoho_product_id)
		@week_sessions = CourseSessionWeekday.where(:course_id => @course.id)
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

	def contact_sales_agent
		user = WebUser.find(params[:userid])
		course = Course.find(params[:courseid])
		WebUserMailer.contact_sales_agent(user,course).deliver
		flash[:notice] = "Tus datos se han enviado a nuestros ejecutivos de ventas.<br> Nos pondremos en contacto contigo dentro de las siguientes 24 horas."
		redirect_to :action => :redirect_view, :controller_name => "site", :action_name => "index"
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

	def register_invoice2(web_user,course)
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

	def register_invoice(web_user,course)
		response = post_data("invoices", format_invoice_for_post(web_user,course))
		if response["code"].to_i == 0
			register_local_invoice(web_user.id,response["invoice"])
			mail_response = mark_invoice_as_sent(response["invoice"]["invoice_id"])
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

	def format_invoice_for_post(customer,course)
		#se obtiene el item correspondiente de zoho
		item_response = get_data_from_zoho("items",course.zoho_product_id)
		if item_response["code"].to_i == 0
			product = item_response["item"]
		else
			return item_response
		end

		invoice = {
			:customer_id => customer.zoho_contact_id,
			:contact_persons => [customer.zoho_contact_person_id],
			#:invoice_number => nil,
			#template_id => nil,
			:date => Date.current().strftime("%Y-%m-%d"),
			:payment_terms => 30,
			:payment_terms_label => "Pago a 30 Días",
			:due_date => (Date.current() + 30.days).strftime("%Y-%m-%d"),
			:discount => course.discount_pct,
			#:is_discount_before_tax => true,
			:discount_type => "entity_level",
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
