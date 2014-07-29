class SiteController < ApplicationController

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
		@courses = Course.where("MONTH(start_date) >= ?", params[:date][:month])
		@selected_month = params[:date][:month]
	end

	private
    def zoho_product_list
    	url = "https://invoice.zoho.com/api/v3/items?authtoken="+zoho_auth_token+"&organization_id="+zoho_organization_id
    	resp = Net::HTTP.get_response(URI.parse(url))
    	return JSON.parse resp.body
    end

    def zoho_organization_id
    	url = "https://invoice.zoho.com/api/v3/organizations?authtoken="+zoho_auth_token
    	resp = Net::HTTP.get_response(URI.parse(url))
    	response = JSON.parse resp.body
    	return response["organizations"][0]["organization_id"]
    end

    def zoho_auth_token
        return "c08fd565113c4bbe94df623ecf397be5"
    end
end
