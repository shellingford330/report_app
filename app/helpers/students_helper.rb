module StudentsHelper
	
	def student_log_in(student)
		session[:student_id] = student.id
	end

	# ログインしている生徒がいればそのユーザーを、していない場合nilを返す
	def	current_student
		@current_student ||= Student.find_by(id: session[:student_id])
	end

	# ログインしている生徒がいればtureを、していない場合falseを返す
	def student_logged_in?
		!current_student.nil?
	end

	# 現在のユーザーをログアウトする
	def	student_log_out
		session.delete(:student_id)
		@current_student = nil
	end
end
