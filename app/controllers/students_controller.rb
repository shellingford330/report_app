class StudentsController < ApplicationController
	before_action :set_student, only: [:show, :edit, :update, :destroy]
	before_action :initialize_student, only: [:new, :login_form]
	def index
		@students = Student.all
	end

	def	new
	end

	def	show
	end

	def edit
	end

	def create
		@student = Student.new(student_params)
		if @student.save
			flash[:success] = "無事作成されました！"
			redirect_to @student
		else
			flash.now[:danger] = "もう一度作成し直してください。"
			render 'new'
		end
	end

	def update
	end

	def destroy
		@student.destroy
		flash[:success] = "無事削除されました！"
		redirect_to students_path
	end

	def	login_form
	end

	def login
		student = Student.find_by(email: params[:student][:email].downcase)
		if student && student.authenticate(params[:student][:password])
			student_log_in(student)
			remember_student(student)
			flash[:success] = "ログインしました！"
			redirect_to student_path(student)
		else
			@student = Student.new(student_params)
			flash.now[:danger] = "もう一度入力情報を確認して下さい。"
			render 'login_form'
		end
	end

	def logout
		forget_student(current_student)
		student_log_out
		redirect_to students_login_path
	end

	private
		def initialize_student
			@student = Student.new
		end

		def	set_student
			@student = Student.find(params[:id])
		end

		def	student_params
			params.require(:student).permit(:name, :email, :password, :password_confirmation)
		end
end
