class InfoController < ApplicationController

	def cursos_individuales_in_office
		@page_title = "Cursos Individuales In Office"
	end

	def workshops_inmersion
		@page_title = "Workshops de Inmersión en Inglés"
	end

	def workshops_interempresariales
		@page_title = "Workshops InterEmpresariales en Inglés"
	end

	def cursos_grupales_in_office
		@page_title = "Cursos de Inglés Grupales In Office"
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

	def cursos_startup_semi_presenciales
		@page_title = "Cursos de Inglés StartUp Semi Presenciales"
	end

	def cursos_toefl
		@page_title = "Curso de Preparación TOEFL"
	end

	def cursos_ielts
		@page_title = "Curso de Preparación IELTS"
	end

	def cursos_toeic
		@page_title = "Curso de Preparación TOEIC"
	end

	def teg_method
		@page_title = "TEG Method"
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
