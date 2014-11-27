class InfoController < ApplicationController

	
	def longbourn_executive
		@page_title = "Longbourn Executive: Cursos de Ingles para Ejecutivos"
	end

	def cursos_toefl
		@page_title = "Cursos TOEFL"
	end

	def cursos_ielts
		@page_title = "Cursos IELTS"
	end

	def cursos_toeic
		@page_title = "Cursos TOEIC"
	end

	def teg_method
		@page_title = "Metodología TEG"
	end

	def cursos_en_sede
		@page_title = "Cursos en nuestra Sede"
	end

	def cursos_empresas
		@page_title = "Cursos para Empresas"
	end

	def longbourn_startup
		@page_title = "Longbourn StartUp"
	end

	def longbourn_institute
		@page_title = "Longbourn Institute: Cursos de Ingles para Profesionales"
		#cursos introductorios en venta
		@active_courses = Course.where(:course_level_id => 1, :course_status_id => 2).limit(6)
	end

	def cursos_internacionales
		@page_title = "Cursos Internacionales"
	end

	def cursos_individuales_in_office
		@page_title = "Cursos Individuales In Office"
	end

	def workshops_inmersion
		@page_title = "Workshops de Inmersión en Inglés"
	end

	def cursos_presenciales
		@page_title = "Cursos de Inglés Presenciales"
	end

	def cursos_semi_presenciales
		@page_title = "Cursos de Inglés Semi Presenciales"
	end

	def cursos_startup_presenciales
		@page_title = "Cursos de Inglés StartUp Presenciales"
	end

	def programas_ejecutivos
		@page_title = "Programas Ejecutivos"
	end

	def programas_corporativos
		@page_title = "Programas Corporativos"
	end

	def soluciones_motivacion
		@page_title = "Soluciones de Motivación"
	end
end
