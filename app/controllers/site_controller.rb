class SiteController < ApplicationController
	require "json"
	require "uri"

	def index
		@types = CourseType.all()
	end

	def available_courses
		raw_products = zoho_product_list
		if raw_products["code"] == 0
			@modes = raw_products["items"].uniq{|i| i["name"]}
		else
			@modes = nil
		end
		@courses = Course.where("MONTH(start_date) BETWEEN (#{params[:date][:month]}-2) AND (#{params[:date][:month]}+2)")
		@selected_month = params[:date][:month]
	end

	def load_extra_content
		@courses = Course.where("MONTH(start_date) = #{params[:month]}")
		@course_features = CourseFeature.where(:course_id => @courses.map{|c| c.id})
		respond_to do |format|
			format.js
		end
	end

	def client_registration
		@course = Course.find(params[:id])
		@course_features = CourseFeature.where(:course_id => @course.id)
	end

	def register_new_client
		@contact = {:contact_name => params[:firstname]+" "+params[:lastname],
					:company_name => params[:organization],
					:billing_address => {
						:address => params[:address],
						:city => params[:city],
						:country => "Chile"
						},
					:contact_persons => [
						:salutation => "Sr.",
						:first_name => params[:firstname],
						:last_name => params[:lastname],
						:email => params[:email],
						:phone => "1234",
						:is_primary_contact => "true"
						]
			}
		uri = URI.parse("https://invoice.zoho.com/api/v3/contacts")
		resp = Net::HTTP.post_form(uri, {"authtoken" => zoho_auth_token, "organization_id" => zoho_organization_id,"JSONString" => @contact.to_json})
		response = JSON.parse resp.body
		if response["code"].to_i == 0
			redirect_to :action => :confirm_purchase, :params => {:course_data => @response}
		else
			@code = response
			@auth = zoho_auth_token
			@org = zoho_organization_id 
		end
	end

	def confirm_purchase

	end

	private
    def zoho_product_list
    	data = get_zoho_data("Longbourn")
    	url = "https://invoice.zoho.com/api/v3/items?authtoken="+data.authtoken+"&organization_id="+data.organization_id
    	resp = Net::HTTP.get_response(URI.parse(url))
    	return JSON.parse resp.body
    end

    def get_zoho_data(organization)
    	return ZohoOrganizationData.where(:organization_name => organization).first()
    end
end
