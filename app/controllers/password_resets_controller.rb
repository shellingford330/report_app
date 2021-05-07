# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :set_user,    only: %i[edit update]
  before_action :valid_user?, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def create
    @user = if params[:password_reset][:email]
              Teacher.find_by(email: params[:password_reset][:email].downcase)
            else
              Student.find_by(login_id: params[:password_reset][:login_id])
            end

    if @user&.activated?
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = "パスワード再設定用のメールを送信しました"
    else
      flash[:danger] = "無効なユーザーです"
    end
    redirect_to_login_form_of(@user)
  end

  def edit
    render 'edit', layout: 'login'
  end

  def update
    password = @user.is_a?(Teacher) ? params[:teacher][:password] : params[:student][:password]
    if password.empty?
      @user.errors.add(:password, :blank)
      render 'edit', layout: 'login'
    elsif @user.update(user_params)
      @user.is_a?(Teacher) ? teacher_log_in(@user) : student_log_in(@user)
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "パスワードを再設定しました"
      redirect_to @user
    else
      render 'edit', layout: 'login'
    end
  end

  private

  def user_params
    if @user.is_a?(Teacher)
      params.require(:teacher).permit(:password, :password_confirmation)
    else
      params.require(:student).permit(:password, :password_confirmation)
    end
  end

  # before フィルタ
  def set_user
    @user = if params[:email]
              Teacher.find_by(email: params[:email])
            else
              Student.find_by(login_id: params[:login_id])
            end
  end

  def valid_user?
    redirect_to_login_form_of(@user) unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
  end

  # トークンが期限切れか確認
  def check_expiration
    if @user.reset_sent_at < 2.hours.ago
      flash[:danger] = "パスワード再設定は期限切れです"
      redirect_to_login_form_of(@user)
    end
  end

  def redirect_to_login_form_of(user)
    if user.is_a?(Teacher)
      redirect_to login_form_teachers_path and return
    else
      redirect_to root_path and return
    end
  end
end
