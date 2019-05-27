class StudentActivationsController < ApplicationController

	def show
		student = Student.find_by(login_id: params[:login_id])
		if authenticated?(student)
			student.create_activation_digest
			student.save
			student.send_authenticate_student_mail
			flash[:success] = "承認されるのをお待ち下さい"
		else
			flash[:danger] = "有効化リンクが無効となっています"
		end
		redirect_to students_login_url
	end

	def edit
		student = Student.find_by(login_id: params[:login_id])
		if authenticated?(student)
			student.update(activated: true, activated_at: Time.zone.now)
			student.send_create_student_mail
			flash[:success] = "生徒に承認メールを送信しました"
		else
			flash[:danger] = "有効化リンクが無効となっています"
		end
		redirect_to login_form_teachers_url
	end

	private

		# 承認された正しい生徒かどうか
		def authenticated?(student)
			student && !student.activated? && student.authenticated?(:activation, params[:id])
		end
end
