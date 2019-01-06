module StudentsHelper
	def student_log_in(student)
		session[:student_id] = student.id
	end

	def	current_student
		@current_student ||= Student.find_by(id:session[:student_id])
	end

	def student_logged_in?
		!current_student.nil?
	end
end
