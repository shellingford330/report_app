class StudentsController < ApplicationController
	before_action :set_student,       only: [:show, :edit, :update, :destroy]
	before_action :already_logged_in, only: [:login_form, :login]
	before_action :owner_logged_in,   only: [:destroy, :upgrade]
	before_action :correct_student_or_admin, only: [:edit, :update]

	def index
		teacher_logged_in
	end

	def	show
		if correct_student?(@student)
			@reports = @student.reports.released.limit(3)
			@news = @student.news.released.limit(3)
		elsif teacher_logged_in?
			@reports = @student.reports.limit(3)
			@news = @student.news.limit(3)
		else
			redirect_to students_login_path
		end
	end

	def edit
	end

	def update
		if @student.update(student_params)
			flash[:success] = "更新しました"
			redirect_to @student
		else
			flash.now[:danger] = "入力情報をご確認下さい"
			render 'edit'
		end
	end

	def upgrade
		change_into_index = { "年少" => 0, "年中" => 1, "年長" => 2, "小学１年生" => 3, "小学２年生" => 4, "小学３年生" => 5, 
			"小学４年生" => 6, "小学５年生" => 7, "小学６年生" => 8, "中学１年生" => 9, "中学２年生" => 10, "中学３年生" => 11, 
			"高校１年生" => 12, "高校２年生" => 13, "高校３年生" => 14, "大学１年生" => 15, "大学２年生" => 16, "大学３年生" => 17, "大学４年生" => 18 }
		Student.all.each do |student|
			up_idx = ( change_into_index[student.grade] + 1 ) % 19
			upgrade = Student.grades[up_idx]
			student.update(grade: upgrade)
		end
		redirect_to students_path
	end

	def create
		student = Student.new(student_params)
		# メールアドレスの@の前のドメインを取得
		domain =  /@/.match(student.email).try(:pre_match)
		student.login_id = "#{domain}_#{student.first_name}"
		if student.save
			student.send_account_activation_mail
			flash[:success] = "アカウント有効化メールを送信しました"
			head 201
		else
			flash.now[:danger] = "入力情報をご確認下さい"
			render json: { messages: student.errors.full_messages }, status: 422
		end
	end

	def destroy
		@student.destroy
		flash[:success] = "生徒が削除されました"
		redirect_to students_url
	end

	def	login_form
		@student = Student.new
		render layout: 'login'
	end

	def login
		@student = Student.find_by(login_id: params[:student][:login_id])
		# 生徒が見つかったか
		unless @student
			@student = Student.new
			flash.now[:danger] = "生徒が見つかりませんでした"
			render 'login_form', layout: 'login' and return
		end
		# パスワードが間違っているか
		unless @student.authenticate(params[:student][:password])
			flash.now[:danger] = "パスワードが間違っております"
			render 'login_form', layout: 'login' and return
		end
		# 有効化されているか
		unless @student.activated?
			flash[:danger] = "アカウントが有効化されていません。メールをご確認下さい"
			redirect_to students_login_url and return
		end
		student_log_in(@student)
		params[:remember_me] == 'yes' ? remember_student(@student) : forget_student(@student)
		flash[:notice] = "ログインしました"
		redirect_back_to student_path(@student)
	end

	def logout
		student_log_out if student_logged_in?
		redirect_to students_login_path
	end

	private
		def	student_params
			# 更新用
			if admin_logged_in?
				params[:student][:lesson_day] = params[:student][:lesson_days].join(" ")
				params.require(:student).permit(:name, :grade, :lesson_day)
			elsif student_logged_in?
				params[:student][:lesson_day] = params[:student][:lesson_days].join(" ")
				params.require(:student).permit(
					:name, :grade, :email, :lesson_day, :image, :image_cache, :remove_image, 
					:password, :password_confirmation
				)
			# 登録用
			else
				params.require(:student).permit(
					:name, :grade, :email, :first_name, :last_name, :password, :password_confirmation
				)
			end
		end

		# beforeアクション

		def	set_student
			@student = Student.find(params[:id])
			unless @student.activated?
				flash[:danger] = "アカウントが有効化されていません"
				redirect_to students_login_url and return
			end
		end

		def already_logged_in
			redirect_to current_student and return if student_logged_in?
		end

		def correct_student_or_admin
			unless admin_logged_in? || correct_student?(@student)
				store_location
				redirect_to students_login_url and return
			end
		end

end
