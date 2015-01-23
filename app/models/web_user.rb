class WebUser < ActiveRecord::Base
	require 'bcrypt'
	validates :email, uniqueness: true, presence: true 
	before_create :set_defaults
	before_create  {generate_token(:oauth_token)}
	before_update :set_course_level

	def generate_token(column)
		unless self[column]
			begin
				self[column] = SecureRandom.urlsafe_base64
			end while WebUser.exists?(column => self[column])
		end
	end

	def get_password
		@password ||= BCrypt::Password.new(password)
	end

	def set_password
		#Se usa bcrypt para el hash de la contraseña
		self.password = BCrypt::Password.create(self.password)
	end

	def set_course_level
		## Se supone que aca se define el nivel del curso en que estará el alumno
		## Utilizando el puntaje obtenido en el test
		if self.test_score.nil?
			self.course_level_id = nil
		elsif self.test_score < 20
			#nivel introductorio
			self.course_level_id = 1
		elsif self.test_score < 40
			#nivel standard
			self.course_level_id = 2
		elsif self.test_score < 60
			#nivel experto
			self.course_level_id = 3
		else
			#nivel superior
			self.course_level_id = 4
		end
	end

	def set_defaults
		self.zoho_enabled = false
		self.moodle_enabled = false
		if self.provider.nil? || self.provider.empty?
			self.provider = "web_longbourn"
			self.name = self.firstname+" "+self.lastname
		end
		#para evitar error de ActiveRecord::RecordNotSaved
		return nil
	end

	def self.from_omniauth(auth)
		where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.name = auth.info.name
			user.firstname = auth.info.first_name
			user.lastname = auth.info.last_name
			user.facebook_email = auth.info.email
			if user.email.nil? || user.email ==  ""
				user.email = auth.info.email
			end
			user.gender = auth.extra.raw_info.gender
			user.facebook_location =  auth.info.location
			if user.location.nil? || user.location == ""
				user.location = auth.info.location
			end
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			user.save!
		end
	end
end
