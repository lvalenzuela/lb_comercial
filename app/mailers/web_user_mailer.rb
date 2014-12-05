class WebUserMailer < ActionMailer::Base
  default from: "info@longbourn.cl"

  def user_registration(key_code, user)
  	@url = longbourn_url+"/users/user_identification?user_auth_token="+key_code
  	@user = user
  	case user.gender
  	when "male"
  		@greeting = "Estimado"
  	when "female"
  		@greeting = "Estimada"
  	else
  		@greeting = "Estimad@"
  	end
  	@course_level = CourseLevel.find(@user.course_level_id).course_level
  	mail(to: user.email, subject: "Longbourn Institute: Registro de Usuarios de Longbourn.")
  end

  def user_login(key_code, user)
  	@url = longbourn_url+"/users/user_identification?user_auth_token="+key_code
  	@user = user
  	case user.gender
  	when "male"
  		@greeting = "Estimado"
  	when "female"
  		@greeting = "Estimada"
  	else
  		@greeting = "Estimad@"
  	end
  	mail(to: user.email, subject: "Longbourn Institute: Registro de Usuarios de Longbourn.")
  end

  def contact_sales_agent(web_contact)
    @contact = web_contact
    mail(to: "aarregui@longbourn.cl", subject: "Contacto Web Comercial: #{web_contact.name}")
  end

  private

  def longbourn_url
  	return "http://localhost:3000"
  end
end
