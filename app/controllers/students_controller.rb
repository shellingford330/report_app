class StudentsController < ApplicationController
	before_action :student_already_logged_in,  only: [:login_form, :login]
	before_action :teacher_logged_in, only: [:index ,:new, :create, :destroy]
	before_action :owner_logged_in,   only: [:new, :create, :destroy, :upgrade]
	before_action :student_logged_in, only: [:edit, :update]
	before_action :correct_student,   only: [:edit, :update]
	before_action :set_student,       only: [:show, :destroy]
	before_action :initialize_student,only: [:new, :login_form]
	before_action :new_student,       only: [:create, :login]

	def index
		@students = Student.all
	end

	def	new
	end

	def	show
		redirect_to students_login_path unless (judge = correct_student?(@student)) || teacher_logged_in?
		if judge
			@reports = @student.reports.where(status: "released")
			.paginate(page: params[:page], per_page: 5)
		else
			@reports = @student.reports.paginate(page: params[:page], per_page: 5)
		end
	end

	def edit
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
		if @student.save
			flash[:success] = "生徒が作成されました"
			redirect_to @student
		else
			flash.now[:danger] = "失敗しました"
			render 'new'
		end
	end

	def update
		if @student.update_attributes(student_params)
			flash[:success] = "更新しました"
			redirect_to @student
		else
			flash.now[:danger] = "入力情報をご確認下さい"
			render 'edit'
		end
	end

	def destroy
		@student.destroy
		flash[:success] = "生徒が削除されました"
		redirect_to students_url
	end

	def	login_form
		render layout: 'login'
	end

	def login
		student = Student.find_by(email: params[:student][:email].downcase)
		if student && student.authenticate(params[:student][:password])
			student_log_in(student)
			params[:remember_me] == 'yes' ? remember_student(student) : forget_student(student)
			flash[:notice] = "ログインしました"
			redirect_back_to student_path(student)
		else
			flash.now[:danger] = "入力情報をご確認下さい"
			render 'login_form', layout: 'login'
		end
	end

	def logout
		student_log_out if student_logged_in?
		redirect_to students_login_path
	end

	private
		def	student_params
			params.require(:student).permit(:name, :grade, :email, :password, :password_confirmation)
		end

		# beforeアクション

		def initialize_student
			@student = Student.new
		end

		def new_student
			@student = Student.new(student_params)
		end

		def	set_student
			@student = Student.find(params[:id])
		end

		# ログインするよう必要があるか確認
		def student_logged_in
			unless student_logged_in?
				flash[:danger] = "ログインをして下さい"
				store_location
				redirect_to students_login_path
			end
		end

		# ログインを既にしているか確認
		def student_already_logged_in
			redirect_to current_student if student_logged_in?
		end

		# ログインしている生徒であるか確認
		def correct_student
			@student = Student.find(params[:id])
			redirect_to current_student unless correct_student?(@student)
		end
end
