class WebContactForm < ActiveRecord::Base
	validates :name, :email, :msg, :presence => true
end
