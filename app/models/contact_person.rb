class ContactPerson < ActiveRecord::Base
	require 'bcrypt'
	validates_confirmation_of :password
	validates :email, uniqueness: true
	validates :rut, uniqueness: true, presence: true
	validate :birthday_cant_be_today

	before_create :set_defaults
	before_create :set_password
	before_create  {generate_token(:auth_token)}

	def set_defaults
		#Por defecto, al crear una cuenta, esta no estará en zoho inmediatamente
		self.zoho_enabled = false
		#Salutation se define segun el género
		if self.gender == "Masculino"
			self.salutation = "Sr."
		else
			self.salutation = "Srta."
		end
	end

	def birthday_cant_be_today
		if birthday.present? && birthday >= Date.today
			errors.add(:birthday, "No puede ser mayor o igual a la fecha actual")
		end
	end

	def get_password
		@password ||= Password.new(password)
	end

	def set_password
		#Se usa bcrypt para el hash de la contraseña
		self.password = BCrypt::Password.create(self.password)
	end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while ContactPerson.exists?(column => self[column])
	end
end
