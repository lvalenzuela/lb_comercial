class InfoController < ApplicationController
	
	def promotions
		@page_title = "Promociones y descuentos en Longbourn"
		@meta_description = "Recomienda Longbourn y accede a increíbles descuentos."
		@user = current_user
		@random = SecureRandom.base64(10)
	end

	def longbourn_startup
		@page_title = "Inglés Empresarial para ejecutivos, ¡En tu propia oficina!"
		@meta_description = "Inglés empresarial con programas In Office y metodología TEG, orientados a ejecutivos y profesionales. Código SENCE. Niveles básico, intermedio y avanzado."
		@active_courses = Course.where(:course_status_id => 2).limit(6)
	end

	def longbourn_institute
		@page_title = "Instituto de Inglés en Santiago de Chile para profesionales"
		@meta_description = "Instituto de Inglés en Santiago de Chile: enfocado a empresas y profesionales, grupos de 8 participantes, metodología TEG, y ¡los mejores horarios!"
		#cursos introductorios en venta
		@active_courses = Course.where(:course_status_id => 2).limit(6)
	end

	def longbourn_executive
		@page_title = "Inglés Ejecutivo para profesionales, ¡En tu propia oficina!"
		@meta_description = "Inglés ejecutivo con programas In Office y metodología TEG, orientados a ejecutivos y profesionales. Código SENCE. Niveles básico, intermedio y avanzado."
		@active_courses = Course.where(:course_status_id => 2).limit(6)
	end

	def cursos_toefl
		@page_title = "Cursos TOEFL Chile, Test Of English as a Foreign Language"
		@meta_description = "Cursos TOEFL en Santiago de Chile: preparación para el Test Of English as a Foreign Language (TOEFL), ¡el exámen de certificación más respetado del mundo!"
	end

	def cursos_ielts
		@page_title = "Cursos IELTS"
		@meta_description = ""
	end

	def cursos_toeic
		@page_title = "Cursos TOEIC"
		@meta_description = ""
	end

	def teg_method
		@page_title = "Metodología TEG: leer, escribir, escuchar y hablar"
		@meta_description = "La Metodología TEG desarrolla simultáneamente, de forma diferente, dinámica y entretenida, las 4 habilidades del inglés: leer, escribir, escuchar y hablar."
	end

	def cursos_en_sede
		@page_title = "Cursos Inglés en Las Condes para profesionales y ejecutivos"
		@meta_description = "Cursos de inglés en Las Condes para profesionales, ejecutivos y empresas, en nuestra sede de comuna Las Condes y/o en tu propia oficina."
	end

	def cursos_empresas
		@page_title = "Cursos de Inglés para Empresas, PYMES y MIPYMES en Santiago"
		@meta_description = "Cursos de Inglés para empresas y toda clase de compañías PYMES o MIPYMES, presenciales o in office, ¡clases de inglés en su oficina! ¡Contáctanos!"
	end

	def cursos_internacionales
		@page_title = "Cursos Internacionales"
		@meta_description = ""
	end

	def cursos_individuales_in_office
		@page_title = "Cursos Individuales In Office"
		@meta_description = ""
	end

	def workshops_inmersion
		@page_title = "Workshops de Inmersión en Inglés"
		@meta_description = ""
	end

	def cursos_presenciales
		@page_title = "Cursos de Inglés Presenciales"
		@meta_description = ""
	end

	def cursos_semi_presenciales
		@page_title = "Cursos de Inglés Semi Presenciales"
		@meta_description = ""
	end

	def cursos_startup_presenciales
		@page_title = "Cursos de Inglés StartUp Presenciales"
		@meta_description = ""
	end

	def programas_ejecutivos
		@page_title = "Programas Ejecutivos"
		@meta_description = ""
	end

	def programas_corporativos
		@page_title = "Programas Corporativos"
		@meta_description = ""
	end

	def soluciones_motivacion
		@page_title = "Soluciones de Motivación"
		@meta_description = ""
	end
end
