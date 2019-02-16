module ApplicationHelper
	def user_logged_in?
    !current_user.nil?
	end
	
	def	current_user
		@current_user ||= current_student || current_teacher
	end
end
