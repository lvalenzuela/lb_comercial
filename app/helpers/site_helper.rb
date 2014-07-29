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
end
