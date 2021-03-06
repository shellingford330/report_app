# frozen_string_literal: true

class StudentActivationsController < ApplicationController
  # 生徒が登録したメールアドレスが本人か確認
  def show
    student = Student.find_by(login_id: params[:login_id])
    if student && !student.activated? && student.authenticated?(:activation, params[:id])
      student.create_activation_digest
      student.save
      student.send_authenticate_student_mail
      flash[:success] = "承認されるのをお待ち下さい"
    else
      flash[:danger] = "有効化リンクが無効となっています"
    end
    redirect_to root_url
  end

  # 塾側が塾生か確認
  def edit
    student = Student.find_by(login_id: params[:login_id])
    if student && !student.activated? && student.authenticated?(:activation, params[:id])
      student.update(activated: true, activated_at: Time.zone.now)
      student.send_create_student_mail
      flash[:success] = "生徒に承認メールを送信しました"
    else
      flash[:danger] = "有効化リンクが無効となっています"
    end
    redirect_to login_form_teachers_url
  end
end
