class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	include ApplicationHelper
  include StudentsHelper
	include TeachersHelper
	include ReportsHelper
	
  # アクセスしようとしたURL(なければデフォルト値)にリダイレクト
	def redirect_back_to (default)
		redirect_to (session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	# アクセスしようとしたURLを保存
	def	store_location
		session[:forwarding_url] = request.original_url if request.get?
	end
	
	private
		# 共通のbefore_action

		# ログインしているユーザーがいるか確認
		def user_logged_in
			unless user_logged_in?
				flash[:danger] = "ログインをして下さい"
				store_location
				redirect_to students_login_path
			end
		end

		# ログインするよう必要があるか確認
		def student_logged_in
			unless student_logged_in?
				flash[:danger] = "ログインをして下さい"
				store_location
				redirect_to students_login_path
			end
		end

		# 講師がログインをするよう必要があるか確認
		def teacher_logged_in
			unless teacher_logged_in?
				flash[:danger] = "ログインをして下さい"
				store_location
				redirect_to login_form_teachers_path
			end
		end

		# オーナーであるか確認
		def owner_logged_in
			unless owner_logged_in?
				flash[:danger] = "ログインをして下さい"
				store_location
				redirect_to login_form_teachers_path
			end
		end

		# ログインしているのが認証された講師か確認
    def admin_logged_in
      unless admin_logged_in?
        store_location
        redirect_to login_form_teachers_url
      end
    end

end
