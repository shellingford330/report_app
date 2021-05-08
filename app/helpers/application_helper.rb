# frozen_string_literal: true

module ApplicationHelper
  # ログインしているユーザーがいればtrue,いなければfalseを返す
  def user_logged_in?
    !current_user.nil?
  end

  # ログインしているユーザーいればそのユーザーを、いなければnilを返す
  def	current_user
    @current_user ||= current_student || current_teacher
  end
end
