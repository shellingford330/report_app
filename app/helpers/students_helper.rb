module StudentsHelper
	# 渡された生徒をログイン状態にする
	def student_log_in(student)
		session[:student_id] = student.id
	end

	# 渡された生徒をcookiesに保存する
	def remember_student(student)
		student.remember
		cookies.permanent.signed[:student_id] = student.id
		cookies.permanent[:remember_token] = student.remember_token
	end

	# 渡された生徒のcookiesを削除する
	def	forget_student(student)
		student.forget
		cookies.delete(:student_id)
		cookies.delete(:remember_token)
	end

	# ログインしている生徒がいればそのユーザーを、していない場合nilを返す
	def	current_student
		if (student_id = session[:student_id])
			@current_student ||= Student.find_by(id: student_id)
		elsif (student_id = cookies.signed[:student_id])
			student = Student.find_by(id: student_id)
			if (student && student.authenticated?(cookies[:remember_token]))
				student_log_in(student)
				@current_student = student
			end
		end
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
