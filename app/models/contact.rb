class Contact < ActiveRecord::Base
	before_create :set_defaults
	validates :contact_name, uniqueness: true, presence: true

	def set_defaults
		#Por el momento, el pais de un contacto sera siempre Chile
		self.country = "Chile"
	end
end
