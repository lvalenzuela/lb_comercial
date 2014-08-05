module SiteHelper
	def get_month_name(month_number)
		case month_number
		when [1,13]
			return "Enero"
		when [2,14]
			return "Febrero"
		when 3
			return "Marzo"
		when 4
			return "Abril"
		when 5
			return "Mayo"
		when 6
			return "Junio"
		when 7
			return "Julio"
		when 8
			return "Agosto"
		when 9
			return "Septiembre"
		when 10
			return "Octubre"
		when [11,-1]
			return "Noviembre"
		when [12,0]
			return "Diciembre"
		end
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
end
