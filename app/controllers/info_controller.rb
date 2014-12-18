class InfoController < ApplicationController
	
	def longbourn_startup
		@page_title = "Inglés Empresarial para ejecutivos, ¡En tu propia oficina!"
		@active_courses = Course.where(:course_status_id => 2).limit(6)
	end

	def longbourn_institute
		@page_title = "Instituto de Inglés en Santiago de Chile para profesionales"
		#cursos introductorios en venta
		@active_courses = Course.where(:course_status_id => 2).limit(6)
	end

	def longbourn_executive
		@page_title = "Inglés Ejecutivo para profesionales, ¡En tu propia oficina!"
		@active_courses = Course.where(:course_status_id => 2).limit(6)
	end

	def cursos_toefl
		@page_title = "Cursos TOEFL Chile, Test Of English as a Foreign Language"
	end

	def cursos_ielts
		@page_title = "Cursos IELTS"
	end

	def cursos_toeic
		@page_title = "Cursos TOEIC"
	end

	def teg_method
		@page_title = "Metodología TEG: leer, escribir, escuchar y hablar"
	end

	def cursos_en_sede
		@page_title = "Cursos Inglés en Las Condes para profesionales y ejecutivos"
	end

	def cursos_empresas
		@page_title = "Cursos de Inglés para Empresas, PYMES y MIPYMES en Santiago"
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
