class AccountActivationsController < ApplicationController

	def show
		student = Student.find_by(login_id: params[:login_id])
		if student && !student.activated? && student.authenticated?(:activation, params[:id])
			student.update(activation_digest: Student.digest(student.activation_token))
			student.send_authenticate_student_mail
			flash[:success] = "承認されるのをお待ち下さい"
		else
			flash[:danger] = "有効化リンクが無効となっています"
		end
		redirect_to students_login_url
	end

	def edit
		student = Student.find_by(login_id: params[:login_id])
		if student.authenticated?(:activation, params[:id])
			student.update(activated: true, activated_at: Time.zone.now)
			flash[:success] = "生徒に承認メールを送信しました"
		else
			flash[:danger] = "有効化リンクが無効となっています"
		end
		redirect_to login_form_teachers_url
	end
end
