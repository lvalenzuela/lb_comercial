class PromotionsController < ApplicationController

	def index
		redirect_to :action => :promo_referral
	end

	def promo_referral
		@page_title = "Promociones y descuentos en Longbourn"
		@meta_description = "Recomienda Longbourn y accede a increíbles descuentos."
		@user = current_user

		#datos de la promoción actual
		#Esta página estará centrada en la promocion de referencias de usuarios
		#su abreviación es 'user_referral'
		promo_id = get_promo_id("user_referral")
		@promo_data = Promotion.find(promo_id)

		if @user.blank?
			#el usuario no está logeado
			#no se hace nada
		else
			check_if_referenced()
			#probando promocion de registro en facebook
			#promocion de registro por facebook es la id 1
			promo_user_data = PromotionUser.where(:promotion_id => promo_id, :user_id => @user.id)
			if promo_user_data.blank?
				#el usuario no ha sido incluido en la promocion
				#se crean entradas nuevas para el usuario
				#promo_token
				PromotionUser.create(:promotion_id => promo_id, :user_id => @user.id, :promotion_attribute_id => promo_attribute_id(promo_id, "promo_token"), :attribute_value => generate_unique_token(promo_id))
				#referal_counter
				PromotionUser.create(:promotion_id => promo_id, :user_id => @user.id, :promotion_attribute_id => promo_attribute_id(promo_id, "referral_counter"), :attribute_value => 0)
				#facebook_enabled
				PromotionUser.create(:promotion_id => promo_id, :user_id => @user.id, :promotion_attribute_id => promo_attribute_id(promo_id, "facebook_enabled"), :attribute_value => 1)
				#total_discount
				PromotionUser.create(:promotion_id => promo_id, :user_id => @user.id, :promotion_attribute_id => promo_attribute_id(promo_id, "total_discount"), :attribute_value => @promo_data.discount_index)
				@user_data = PromotionUser.where(:promotion_id => promo_id, :user_id => @user.id)

			else
				#el usuario está incluido en la promocion
				#total_discount = promo_user_data.find_by_promotion_attribute_id(promo_attribute_id(promo_id, "total_discount"))
				#total_discount.attribute_value = referral_total_discount(promo_user_data.find_by_promotion_attribute_id(promo_attribute_id(promo_id, "referral_counter")).attribute_value.to_i, @promo_data.discount_index)
				#total_discount.save!

				@user_data = promo_user_data
			end
		end
	end

	def promo_referral_landing
		@page_title = "Promociones y descuentos en Longbourn"
		@meta_description = "Recomienda Longbourn y accede a increíbles descuentos."
		#Solo habrá un usuario con el código señalado en la promocion indicada
		promo_id = get_promo_id("user_referral")
		user = current_user
		if user.blank?
			main_user_data = PromotionUser.where(:promotion_id => promo_id, :attribute_value => params[:code]).first()
			if !main_user_data.blank?
				@main_user = WebUser.find(main_user_data.user_id)
				@code = params[:code]
			else
				redirect_to :action => :promo_referral
			end
		else
			redirect_to :action => :promo_referral
		end
	end

	def register_by_referral
		promo_id = get_promo_id("user_referral")
		#se registra el usuario que hizo la referencia
		session[:referral_main_user_id] = PromotionUser.where(:promotion_id => promo_id, :attribute_value => params[:code]).first().user_id
		#enviar a registro mediante facebook
		redirect_to "/auth/facebook"
	end

	def send_promo_mail
		if params[:promotion_name]
			case params[:promotion_name]
			when "referral"
				contacts_array = params[:contact_emails].split(",")
				contacts_array.each do |contact|
					WebUserMailer.referral_contact(contact, current_user, "#{root_url}comparte-longbourn-con-tus-amigos?code=#{params[:user_code]}").deliver
				end
				flash[:notice] = "Los correos de notificación han sido enviados satisfactoriamente."
			else
				flash[:notice] = "La promocion ingresada no es válida actualmente."
			end
		end
		redirect_to :action => :promo_referral
	end

	def send_contact_info
		@contact_form = WebContactForm.create(web_contact_form_params)
		if @contact_form.valid?
			flash[:notice] = "Tu solicitud ha sido enviada satisfactoriamente. Nos pondremos en contacto contigo a la brevedad."
			WebUserMailer.contact_sales_agent(@contact_form).deliver
		else
			flash[:notice] = "Tu solicitud no pudo ser enviada. Intentalo de nuevo por favor."
		end
		redirect_to :action => :promo_referral
	end

	private

	def web_contact_form_params
		params.require(:web_contact_form).permit(:name, :email, :location, :phone, :msg)
	end

	def referral_total_discount(referral_counter,promo_discount)
		case referral_counter
		when 0
			return promo_discount
		when 1..3
			return 1.5*promo_discount
		when 4..5
			return 2*promo_discount
		else
			return 3*promo_discount
		end
	end

	def promo_attribute_id(promo_id, att_name)
		#retorna el número correspondiente al atributo que se desea recuperar
		return PromotionUserAttribute.where(:promotion_id => promo_id, :attribute_name => att_name).first().sort_order
	end

	def get_promo_id(promo_shortname)
		#Retorna el id de una promocion determinada segun su nombre abreviado
		return Promotion.find_by_shortname(promo_shortname).id
	end

	def check_if_referenced
		if session[:referral_main_user_id] && session[:referral_main_user_id] != current_user.id
			#El usuario fue referido por otro usuario
			promo_id = get_promo_id("user_referral")
			exists = PromotionUser.where(:promotion_id => promo_id, :user_id => session[:referral_main_user_id], :promotion_attribute_id => promo_attribute_id(promo_id, "referenced_user_id"), :attribute_value => current_user.id)
			if exists.blank?
				promotion_user_data = PromotionUser.where(:promotion_id => promo_id, :user_id => session[:referral_main_user_id])
				#el usuario viene de un link de referencia
				#la referencia fue hecha por otro usuario
				#es primera vez que el usuario se registra mediante una referencia para ese usuario
				#y el valor de session[:referral_main_user_id] es el id del usuario que lo recomendó
				referral_counter = promotion_user_data.find_by_promotion_attribute_id(promo_attribute_id(promo_id, "referral_counter"))
				referral_counter.attribute_value = referral_counter.attribute_value.to_i + 1
				#se suma una referencia al contador de referencias del usuario
				referral_counter.save!
				#Se registra que el usuario fue referido
				new_referred_user = PromotionUser.new()
				new_referred_user.promotion_id = promo_id
				new_referred_user.user_id = session[:referral_main_user_id]
				new_referred_user.promotion_attribute_id = promo_attribute_id(promo_id, "referenced_user_id")
				new_referred_user.attribute_value = current_user.id
				new_referred_user.save!
				#se modifica el descuento total del usuario principal
				main_user_discount = promotion_user_data.find_by_promotion_attribute_id(promo_attribute_id(promo_id, "total_discount"))
				main_user_discount.attribute_value = referral_total_discount(promotion_user_data.find_by_promotion_attribute_id(promo_attribute_id(promo_id, "referral_counter")).attribute_value.to_i, Promotion.find(promo_id).discount_index)
				main_user_discount.save!
			else
				#el usuario ya fue referido
				#no se suma la referencia al contador
			end
		end
	end

	def generate_unique_token(promo_id)
		#genera un token único para una promocion determinada
		begin
			random_token = SecureRandom.base64(10)
		end while PromotionUser.exists?(:promotion_id => promo_id, :attribute_value => random_token)
		return random_token
	end
end
