class ContactPerson < ActiveRecord::Base
	require 'bcrypt'
	validates_confirmation_of :password
	before_create :set_defaults
	before_create :set_password

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

	def get_password
		@password ||= Password.new(password)
	end

	def set_password
		#Se usa bcrypt para el hash de la contraseña
		self.password = BCrypt::Password.create(self.password)
	end
end
