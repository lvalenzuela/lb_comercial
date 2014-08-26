module SiteHelper
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
		teacher = User.find(teacher_id)
		return teacher.firstname+" "+teacher.lastname
	end

	def available_courses_for_month(courses,date,mode)
		if date == Time.now
			return courses.where("start_date BETWEEN '#{(date + 1.days).strftime('%Y-%m-%d')}' AND '#{(date + 1.weeks).end_of_week.strftime('%Y-%m-%d')}' AND mode = '#{mode}'").count
		else
			return courses.where("start_date BETWEEN '#{date.beginning_of_week.strftime('%Y-%m-%d')}' AND '#{(date + 1.weeks).end_of_week.strftime('%Y-%m-%d')}' AND mode = '#{mode}'").count
		end
	end

	def get_teacher_image(teacher_id)
		return User.find(teacher_id).avatar.url
	end

	def price_with_discount(course,features)
		price = get_course_feature(features.where(:course_id => course.id),"price").to_i
		return price * (100 - course.discount_factor)/100
	end
end
