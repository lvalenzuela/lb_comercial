module SiteHelper

	def route_bg_color(course_level)
		case course_level
		when 1 #introductory
			return "#8ec449"
		when 2 #standard
			return "#e67e22"
		when 3 #expert
			return "#3498db"
		else #superior
			return "#563d7c"
		end
	end

	def classroom_matching_label(matching_id)
		if matching_id
			return ClassroomMatching.find(matching_id).matching_label
		else
			return ""
		end
	end

	def location_label(location_id)
		if location_id
			return Location.find(location_id).name
		else
			return ""
		end
	end

	def week_day(day_number)
		case day_number
		when 1
			return "Lunes"
		when 2
			return "Martes"
		when 3
			return "Miércoles"
		when 4
			return "Jueves"
		when 5
			return "Viernes"
		when 6
			return "Sábado"
		else
			return "Domingo"
		end
	end

	def course_mode_name(mode_id)
		return CourseMode.find(mode_id).mode_name
	end

	def get_course_level_name(level_id)
		return CourseLevel.find(level_id).course_level
	end

	def disabled_course(courses,month)
		if courses.select{|c| c.start_date.month == month}
			return false
		else
			return true
		end
	end

	def get_coursetype(id)
		CourseType.find(id).typename
	end

	def get_course_feature(course_features, desired)
		feature = course_features.where(:feature_name => desired)
		if feature.nil? || feature.blank?
			return ""
		else
			return feature.first().feature_description
		end
	end

	def get_teacher_name(teacher_id)
		teacher = TeacherV.find(teacher_id)
		return teacher.name
	end

	def available_courses_for_month(courses,date,mode)
		if date == Time.now
			return courses.where("start_date BETWEEN '#{(date + 1.days).strftime('%Y-%m-%d')}' AND '#{(date + 1.weeks).end_of_week.strftime('%Y-%m-%d')}' AND mode = #{mode}").count
		else
			return courses.where("start_date BETWEEN '#{date.beginning_of_week.strftime('%Y-%m-%d')}' AND '#{(date + 1.weeks).end_of_week.strftime('%Y-%m-%d')}' AND mode = #{mode}").count
		end
	end

	def get_teacher_image(teacher_id)
		return User.find(teacher_id).avatar.url
	end

	def price_with_discount(course)
		price = CourseModeZohoProductMap.find_by_zoho_product_id(course.zoho_product_id).price.to_i
		return price * (100 - course.discount_factor)/100
	end

	def course_price(course)
		CourseModeZohoProductMap.find_by_zoho_product_id(course.zoho_product_id).price.to_i
	end
end
