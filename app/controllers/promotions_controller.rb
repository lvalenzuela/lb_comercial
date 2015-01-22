class PromotionsController < ApplicationController

	def index
		@page_title = "Promociones y descuentos en Longbourn"
		@meta_description = "Recomienda Longbourn y accede a increíbles descuentos."
		@user = current_user
		@promo_data = Promotion.find(4)

		if @user.blank?
			#el usuario no está logeado
			#no se hace nada
		else
			check_if_referenced()
			#probando promocion de registro en facebook
			#promocion de registro por facebook es la id 4
			promo_user_data = PromotionUser.where(:promotion_id => 4, :user_id => @user.id)
			if promo_user_data.blank?
				#el usuario no ha sido incluido en la promocion
				#se crean entradas nuevas para el usuario
				#promo_token
				PromotionUser.create(:promotion_id => 4, :user_id => @user.id, :promotion_attribute_id => 1, :attribute_value => generate_unique_token(4))
				#referal_counter
				PromotionUser.create(:promotion_id => 4, :user_id => @user.id, :promotion_attribute_id => 2, :attribute_value => 0)
				#facebook_enabled
				PromotionUser.create(:promotion_id => 4, :user_id => @user.id, :promotion_attribute_id => 3, :attribute_value => 1)
				@user_data = PromotionUser.where(:promotion_id => 4, :user_id => @user.id)

			else
				#el usuario está incluido en la promocion
				@user_data = promo_user_data
			end

			#para definir el descuento que se aplicará al usuario
			case @user_data.find_by_promotion_attribute_id(2).attribute_value.to_i
			when 0
				@discount_multiplier = 0.5
			when 1..3
				@discount_multiplier = 1.5
			when 4..5
				@discount_multiplier = 2
			else
				@discount_multiplier = 3
			end
		end
	end

	def promo_referral
		@page_title = "Promociones y descuentos en Longbourn"
		@meta_description = "Recomienda Longbourn y accede a increíbles descuentos."
		#Solo habrá un usuario con el código señalado en la promocion indicada
		user = current_user
		if user.blank?
			main_user_data = PromotionUser.where(:promotion_id => 4, :attribute_value => params[:code]).first()
			if !main_user_data.blank?
				@main_user = WebUser.find(main_user_data.id)
				@code = params[:code]
			else
				redirect_to :action => :index
			end
		else
			redirect_to :action => :index
		end
	end

	def register_by_referral
		#se registra el usuario que hizo la referencia
		session[:referral_main_user_id] = PromotionUser.where(:promotion_id => 4, :attribute_value => params[:code]).first().user_id
		#enviar a registro mediante facebook
		redirect_to "/auth/facebook"
	end

	def send_promo_mail
		if params[:promotion_name]
			case params[:promotion_name]
			when "referral"
				contacts_array = params[:contact_emails].split(",")
				contacts_array.each do |contact|
					WebUserMailer.referral_contact(contact, current_user, "#{root_url}promo-refiere-a-tus-amigos?code=#{params[:user_code]}").deliver
				end
				flash[:notice] = "Los correos de notificación han sido enviados satisfactoriamente."
			else
				flash[:notice] = "La promocion ingresada no es válida actualmente."
			end
		end
		redirect_to :action => :index
	end

	private

	def check_if_referenced
		if session[:referral_main_user_id] && session[:referral_main_user_id] != current_user.id
			#el usuario viene de un link de referencia
			#y el valor de session[:referral_main_user_id] es el id del usuario que lo recomendó
			referral_counter = PromotionUser.where(:promotion_id => 4, :user_id => session[:referral_main_user_id], :promotion_attribute_id => 2).first()
			referral_counter.attribute_value = referral_counter.attribute_value.to_i + 1
			#se suma una referencia al contador de referencias del usuario
			referral_counter.save!
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
