module StudentsHelper
	# 渡された生徒をログイン状態にする
	def student_log_in(student)
		session[:student_id] = student.id
	end

	# 現在のユーザーをログアウトする
	def	student_log_out
		forget_student(current_student)
		session.delete(:student_id)
		@current_student = nil
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

	# 渡された生徒とログインしている生徒が同じである場合trueを、違う場合falseを返す
	def correct_student?(student)
		student == current_student
	end

	# アクセスしようとしたURL(なければデフォルト値)にリダイレクト
	def redirect_back_to (default)
		redirect_to (session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	# アクセスしようとしたURLを保存
	def	store_location
		session[:forwarding_url] = request.original_url if request.get?
	end

	# 生徒の合計人数を返す
	def	sum_students
		Student.count
	end
end
