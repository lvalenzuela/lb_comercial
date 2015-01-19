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

    #if @contact.paid_service.include?("Executive")
    #  recipient = "aarregui@longbourn.cl"
    #else
    #  recipient = "contacto@longbourn.cl"
    #end
    mail(to: "contacto@longbourn.cl", subject: "Contacto Web Comercial: #{web_contact.name}")
  end

  def contact_jobs_agent(job_contact)
    @contact = job_contact
    if !@contact.attached_resume.blank?
      attachments["curriculum_"+@contact.name+".pdf"] = File.read(@contact.attached_resume.path)
    end
    mail(to: "ecalderon@longbourn.cl", subject: "Solicitud de Empleo: #{job_contact.name}")
  end

  private

  def longbourn_url
  	return "http://www.longbourn.cl"
  end
end
