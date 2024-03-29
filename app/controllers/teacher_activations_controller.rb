# frozen_string_literal: true

class TeacherActivationsController < ApplicationController
  def show
    teacher = Teacher.find_by(email: params[:email])
    if teacher && !teacher.activated? && teacher.authenticated?(:activation, params[:id])
      teacher.create_activation_digest
      teacher.save
      teacher.send_teacher_authentication_mail
      flash[:success] = "承認されるのをお待ち下さい"
    else
      flash[:danger] = "有効化リンクが無効となっています"
    end
    redirect_to login_form_teachers_url
  end

  def edit
    teacher = Teacher.find_by(email: params[:email])
    if teacher && !teacher.activated? && teacher.authenticated?(:activation, params[:id])
      teacher.update(activated: true, activated_at: Time.zone.now)
      teacher.send_create_teacher_mail
      flash[:success] = "講師に承認メールを送信しました"
    else
      flash[:danger] = "有効化リンクが無効となっています"
    end
    redirect_to login_form_teachers_url
  end
end
