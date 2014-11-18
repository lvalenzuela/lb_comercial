class UsersController < ApplicationController
	require 'nokogiri'

	def user_identification
		user = WebUser.where(:oauth_token => params[:user_auth_token]).first()
		if user.blank? || user.nil?
			#el usuario no existe
			flash[:notice] = "No estas registrado en el sitio. Registrate!"
			redirect_to :controller => :site, :action => :signup
		else
			#login exitoso
			cookies.permanent[:oauth_token] = user.oauth_token
			redirect_to :controller => :site, :action => :available_courses
		end
	end

	def facebook_login
		user = WebUser.from_omniauth(env["omniauth.auth"])
		if session[:test_score] && user.test_score.nil?
			user.test_score = session[:test_score]
			user.save!
		end
		cookies.permanent[:oauth_token] = user.oauth_token
		redirect_to :controller => :site, :action => session[:action_milestone]
	end

	def longbourn_login
		user = WebUser.find_by_email(params[:email])
		if user.blank? || user.nil?
			#Login fallido, el usuario no existe
			flash[:notice] = "No estas registrado en el sitio. <br> Registrate y cotiza tu curso!"
			redirect_to :controller => :site, :action => :redirect_view, :controller_name => "site", :action_name => "signup"
		else
			#login exitoso
			#se envía un mail con el codigo de acceso
			WebUserMailer.user_login(user.oauth_token, user).deliver
			flash[:notice] = "Por favor revise su correo. Se le ha enviado un correo con sus datos de registro."
			redirect_to :controller => :site, :action => :redirect_view
		end
	end


	##Login antiguo, ahora no vamos a usar passwords
	def longbourn_login222
		user = WebUser.where(:email => params[:email]).first()
		if user.blank? || user.provider == "facebook"
			#login fallido
			if session[:action_milestone]
				redirect_to :controller => :site, :action => session[:action_milestone]
			else
				redirect_to root_url
			end
		else
			if user.get_password == params[:password]
				if params[:remember_me]
					cookies.permanent[:oauth_token] = user.oauth_token
					if session[:action_milestone]
						redirect_to :controller => :site, :action => session[:action_milestone]
					else
						redirect_to root_url
					end
				else
					cookies[:oauth_token] = user.oauth_token
					if session[:action_milestone]
						redirect_to :controller => :site, :action => session[:action_milestone]
					else
						redirect_to root_url
					end
				end
			else
				#login fallido, password erronea
				if session[:action_milestone]
					redirect_to :controller => :site, :action => session[:action_milestone]
				else
					redirect_to root_url
				end
			end
		end
	end

	def create
		user = WebUser.create(web_user_params)
		if user.valid?
			#Usuario creado exitosamente
			#Se se logea
			cookies.permanent[:oauth_token] = user.oauth_token
			WebUserMailer.user_registration(user.oauth_token, user).deliver
			if session[:test_score]
				user.test_score = session[:test_score]
				user.save!
			end
			if session[:action_milestone]
				redirect_to :controller => :site, :action => session[:action_milestone]
			else
				redirect_to root_url
			end
		else
			#Error al crear el usuario
			if session[:action_milestone]
				redirect_to :controller => :site, :action => session[:action_milestone]
			else
				redirect_to root_url
			end
		end
	end

	def update
		@user = current_user
		@user.update_attributes(web_user_params)
		if @user.valid?
			#datos del usuario actualizados
			redirect_to :controller => :site, :action => :confirm_purchase
		else
			##no se pudo actualizar los datos del usuario
			render :template => "site/edit_user"
		end
	end

	def logout
		cookies.delete(:oauth_token)
		redirect_to root_url
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

	def web_user_params
		return params.require(:web_user).permit(:firstname, :lastname, :gender, :email, :phone, :location, :mobile)
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
