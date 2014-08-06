class UsersController < ApplicationController

	def register_contact_local
		@contact = Contact.create(	:contact_name => params[:firstname]+" "+params[:lastname]+" ["+params[:email]+"]",
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
				cookies[:auth_token] = contact_person.auth_token
				redirect_to :controller => :site, :action => :available_courses, :mode => session[:selected_mode], :date => {:month => session[:selected_month]}
			else
				flash[:notice] = "Error al registrar nuevo contacto."
				render :controller => :site, :action => :contact_signup
			end
		else
			flash[:notice] = "Error al registrar nuevo contacto."
			render :controller => :site, :action => :contact_signup
		end
	end

	def user_login
		contact_person = ContactPerson.where(:email => params[:email]).first()
		if contact_person.blank? || contact_person.nil?
			flash[:notice] = "Datos de usuario incorrectos."
			redirect_to :controller => :site, :action => :contact_signup
		else
			password = BCrypt::Password.new(contact_person.password)
			if password == params[:password]
				contact = Contact.find(contact_person.contact_id)
				if params[:remember_me]
					cookies.permanent[:auth_token] = contact_person.auth_token
				else
					cookies[:auth_token] = contact_person.auth_token
				end
				redirect_to :controller => :site, :action => :available_courses, :mode => session[:selected_mode], :date => {:month => session[:selected_month]}
			else
				flash[:notice] = "Contraseña Incorrecta"
				redirect_to :controller => :site, :action => :contact_signup
			end
		end
	end

	def register_organization_contact
		@contact = Contact.create(	:contact_name => params[:organization],
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
			if @contact_person.valid?
				
			else
			end
		end
	end

	def user_logout
		cookies.delete(:auth_token)
	    redirect_to :controller => :site, :action => :index
	end

	private

end
