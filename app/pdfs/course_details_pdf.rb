class CourseDetailsPdf < Prawn::Document
	include SiteHelper
	include ActionView::Helpers::NumberHelper

	def initialize(course,view_context)
		super(:margin => 50)
		font "Helvetica"
		repeat :all do
			bounding_box [bounds.left, bounds.top + 30], :width  => bounds.width do
				header(course.coursename)
			end

			bounding_box [bounds.left, bounds.bottom], :width  => bounds.width do
				footer
			end
		end

		bounding_box([bounds.left, bounds.top - 40], :width  => bounds.width, :height => bounds.height - 80) do
			font "Helvetica", :size => 12
			course_details(course)
		end	

		number_pages "<page> de <total>",:at => [480, 0], size:9
	end

	def header(coursename)
		#Header de la pagina de descripcion de cursos
		logo_path = Rails.root.join('app','assets','images','LogoLongbourn1.png')
		move_down 10
		image logo_path, :width => 170, :height => 31
		font "Helvetica", :style => :bold
		draw_text "Detalles del Curso: "+coursename, :at => [190,20], size:13, :inline_format => true
		draw_text "Longbourn Institute", :at => [190,0], size:13
		move_down 10
		stroke_horizontal_rule
	end

	def footer
		#Footer de la pagina de descripcion de cursos
		move_cursor_to 30
		font "Helvetica", :size => 9
		text "Badajoz 130 Oficina 405, esquina Alonso de Córdova, Las Condes", :align => :center
		text "Fono:(56-2)2951 1482 - Correo: contacto@longbourn.cl", :align => :center
		text "www.longbourn.cl", :align => :center
	end

	def course_details(course)
		move_down 20
		font "Helvetica", :style => :bold, :size => 18
		text "Detalles del Curso"
		font "Helvetica", :style => :normal, :size => 12
		move_down 10

		teacher = UserV.find(course.main_teacher_id)
		features = CourseFeature.where(:course_id => course.id)

		data = [["<b>Nombre del Curso</b>",course.coursename],
				["<b>Descripcion</b>", course.description],
				["<b>Modalidad</b>", CourseMode.find(course.mode).mode_name],
				["<b>Fecha de Inicio</b>", I18n.l(course.start_date, :format => :default)],
				["<b>Nombre Profesor</b>", teacher.firstname+" "+teacher.lastname],
				["<b>Ubicación</b>", Location.find(course.location_id).name],
				["<b>Horario</b>", get_course_feature(features.where(:course_id => course.id),"first_day")+" - "+get_course_feature(features.where(:course_id => course.id),"first_day_hour")+" / "+get_course_feature(features.where(:course_id => course.id),"second_day")+" - "+get_course_feature(features.where(:course_id => course.id),"second_day_hour")],
				["<b>Precio</b>", number_to_currency(get_course_feature(features.where(:course_id => course.id),"price").to_i, :precision => 0)]
			]
		table(data, :column_widths => {0 => 150, 1 => 350}, 
					:cell_style => {:align => :left, :valign => :center,:size => 12, :border_width => 0.5, :inline_format => true, :padding => [10,5]}, 
					:position => :center,
					:header => true) do
			cells.style do |c|
				if c.column == 0
					c.background_color = "F0F0F0"
				end
			end
		end
		move_down 15
		text "(*) No olvidar que este PDF es un placeholder del que vamos a poner realmente. Lalala!!"
	end
end