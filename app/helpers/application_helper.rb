module ApplicationHelper
	def get_option(value)
		value.map{|s|[s.name, s.id]}
	end
end
