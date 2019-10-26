class PasswordResetsController < ApplicationController
  before_action :set_user,    only: [:edit, :update]
  before_action :valid_user?, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def create
    if params[:password_reset][:email]
      @user = Teacher.find_by(email: params[:password_reset][:email].downcase)
    else
      @user = Student.find_by(login_id: params[:password_reset][:login_id])
    end

    if @user && @user.activated?
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = "パスワード再設定用のメールを送信しました"
    else
      flash[:danger] = "無効なユーザーです"
    end
    redirect_to_login_form_of(@user)
  end

  def edit
  end

  def update
    password = user.kind_of?(Teacher) ? params[:teacher][:password] : params[:student][:password]
    if password.empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      user.kind_of?(Teacher) ? teacher_log_in(@user) : student_log_in(@user)
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "パスワードを再設定しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    if user.kind_of?(Teacher)
      params.require(:teacher).permit(:password, :password_confirmation)
    else
      params.require(:student).permit(:password, :password_confirmation)
    end
  end

  # before フィルタ
  def set_user
    if params[:email]
      @user = Teacher.find_by(email: params[:email])
    else
      @user = Student.find_by(login_id: params[:login_id])
    end
  end

  def valid_user?
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to_login_form_of(@user)
    end
  end

  # トークンが期限切れか確認
  def check_expiration
    if @user.reset_sent_at < 2.hours.ago
      flash[:danger] = "パスワード再設定は期限切れです"
      redirect_to_login_form_of(@user) 
    end
  end

  def redirect_to_login_form_of(user)
    if user.kind_of?(Teacher)
      redirect_to login_form_teachers_path and return
    else
      redirect_to students_login_path and return
    end
  end
end

