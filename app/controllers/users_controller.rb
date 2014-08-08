class UsersController < ApplicationController
	require 'nokogiri'

	def register_user_contact
		@contact = Contact.create(	:contact_name => params[:firstname]+" "+params[:lastname]+" ["+params[:email]+"]",
									:rut => params[:rut],
									:address => params[:address],
									:city => params[:city],
									:phone => params[:phone]
									)
		if @contact.valid?
			contact_person =  create_contact_people(@contact)
			if contact_person.valid?
				cookies[:auth_token] = contact_person.auth_token
				redirect_to :controller => :site, :action => :available_courses, :mode => session[:selected_mode], :date => {:month => session[:selected_month]}
			else
				flash[:notice] = "Error al registrar nuevo contacto."
				render :template => "site/contact_signup"
			end
		else
			flash[:notice] = "Error al registrar nuevo contacto."
			render :template => "site/contact_signup"
		end
	end

	def create_contact_person
		@contact_person = ContactPerson.create(contact_person_params)
		if @contact_person.valid?
			#se relaciona a la nueva persona con el contacto correspondiente
			@contact_person.update_attributes(:contact_id => current_user.contact_id)
			redirect_to :controller => :site, :action => :confirm_purchase
		else
			render :template => "site/new_contact_person"
		end
	end

	def user_login
		contact_person = ContactPerson.where(:email => params[:email]).first()
		if contact_person.blank? || contact_person.nil?
			flash[:notice] = "Datos de usuario incorrectos."
			redirect_to :controller => :site, :action => :login
		else
			password = BCrypt::Password.new(contact_person.password)
			if password == params[:password]
				if params[:remember_me]
					cookies.permanent[:auth_token] = contact_person.auth_token
				else
					cookies[:auth_token] = contact_person.auth_token
				end
				redirect_to :controller => :site, :action => :available_courses, :mode => session[:selected_mode], :date => {:month => session[:selected_month]}
			else
				flash[:notice] = "Contraseña Incorrecta"
				redirect_to :controller => :site, :action => :login
			end
		end
	end

	def register_lead
		@lead = ZohoLead.create(zoho_lead_params)
		if @lead.valid?
			#Registrar prospecto en zoho CRM
			@response = post_crm_data("Leads",xml_format_lead_info(@lead))
			redirect_to :controller => :site, :action => :registration_success
		else
			render :template => "site/organization_signup"
		end
	end

	def user_logout
		cookies.delete(:auth_token)
	    redirect_to :controller => :site, :action => :index
	end



##########################
#FUNCIONES PRIVADAS DEL CONTROLADOR
##########################
	private

	def contact_person_params
		params.require(:contact_person).permit(:gender, :salutation, :birthday, :firstname, :lastname, :rut, :email, :phone, :mobile, :test_score, :course_level_id)
	end

	def create_contact_people(contact)
		contact_person = ContactPerson.create(	:contact_id => contact.id,
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
												:is_primary_contact => true)
		#Cuando se selecciona la casilla de registrar un curso para otra persona
		if params[:extra_contact_person]
			ContactPerson.create( 	:contact_id => contact.id,
									:gender => params[:student_gender],
									:birthday => params[:student_birthday],
									:firstname => params[:student_firstname],
									:lastname => params[:student_lastname],
									:rut => params[:student_rut],
									:email => params[:student_email],
									:phone => params[:student_phone],
									:mobile => params[:student_mobile])
		end
		return contact_person
	end

	def zoho_lead_params
		return params.require(:zoho_lead).permit(:lead_source, :company, :firstname, :lastname, :gender, :email, :title, :phone, :mobile)
	end

	def xml_format_lead_info(lead)
		builder = Nokogiri::XML::Builder.new { |xml|
			xml.Contacts{
				xml.row("no" => 1) do
					xml.FL("val" => "Lead Owner") do xml.text default_lead_owner end
					xml.FL("val" => "Lead Source") do xml.text lead.lead_source end 
					xml.FL("val" => "Company") do xml.text lead.company end 
					xml.FL("val" => "First Name") do xml.text lead.firstname end 
					xml.FL("val" => "Last Name") do xml.text lead.lastname end
					xml.FL("val" => "Email") do xml.text lead.email end
					xml.FL("val" => "Title") do xml.text lead.title end
					xml.FL("val" => "Phone") do xml.text lead.phone end
					xml.FL("val" => "Mobile") do xml.text lead.mobile end
				end
			}
		}
		return builder.to_xml
	end

	def default_lead_owner
		return "Alvaro Maurelia"
	end

	def get_crm_users(data_type)
		data = zoho_auth_data("Longbourn","crm")
		url = "https://crm.zoho.com/crm/private/json/Users/getUsers?authtoken="+data.authtoken+"&scope=crmapi&type=ActiveUsers"
		resp = Net::HTTP.get_response(URI.parse(url))
		return JSON.parse resp.body
	end

	def post_crm_data(data_type,xml_array)
		data = zoho_auth_data("Longbourn","crm")
		uri = URI.parse("https://crm.zoho.com/crm/private/xml/"+data_type+"/insertRecords")
		resp = Net::HTTP.post_form(uri, {"authtoken" => data.authtoken, "scope" => "crmapi", "newFormat" => "1", "xmlData" => xml_array})
		return Nokogiri::XML resp.body
	end

	def zoho_auth_data(organization,service)
		return ZohoOrganizationData.where(:organization_name => organization, :service => service).first()
	end
end
