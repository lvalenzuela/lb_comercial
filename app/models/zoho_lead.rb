class ZohoLead < ActiveRecord::Base
	validates :company, :firstname, :lastname, :email, :phone, :gender, presence: true
end
