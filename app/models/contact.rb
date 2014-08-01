class Contact < ActiveRecord::Base
	before_create :set_defaults

	def set_defaults
		#Por el momento, el pais de un contacto sera siempre Chile
		self.country = "Chile"
	end
end
