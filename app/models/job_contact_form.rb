class JobContactForm < ActiveRecord::Base
	has_attached_file :attached_resume
	validates_attachment :attached_resume, content_type: { content_type: "application/pdf" }
	validates_attachment :attached_resume, :presence => true
	validates :name, :email, :university, :job_choice, :presence => true
end
