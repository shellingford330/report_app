module TeachersHelper
	# 渡された講師をセッションに保存
	def teacher_log_in(teacher)
		session[:teacher_id] = teacher.id
	end

	# 渡された講師をクッキーに保存
	def remember_teacher(teacher)
		teacher.remember
		cookies.permanent.signed[:teacher_id] = teacher.id
		cookies.permanent[:remember_token] = teacher.remember_token
	end

	# 渡された講師のクッキーを破棄
	def forget_teacher(teacher)
		teacher.forget
		cookies.delete(:teacher_id)
		cookies.delete(:remember_token)
	end

	# 講師のセッションとクッキーを削除
	def teacher_log_out
		forget_teacher(current_teacher)
		session.delete(:teacher_id)
		@current_teacher = nil
	end

	# ログインしている講師が入ればその講師を、いなければnilを返す
	def	current_teacher
		if ( teacher_id = session[:teacher_id] )
			@current_teacher ||= Teacher.find_by(id: teacher_id)
		elsif ( teacher_id = cookies.signed[:teacher_id] )
			teacher = Teacher.find_by(id: teacher_id)
			if ( teacher && teacher.authenticated?(cookies[:remember_token]) )
				teacher_log_in(teacher)
				@current_teacher = teacher
			end
		end
	end

	def teacher_logged_in?
		!current_teacher.nil?
	end
end
