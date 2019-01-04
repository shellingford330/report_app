class StudentsController < ApplicationController
	before_action :set_student, only: [:show, :edit, :update, :destroy]
	def index
		@students = Student.all
	end

	def	new
		@student = Student.new
	end

	def	show
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

	def destroy
		@student.destroy
		redirect_to students_path
	end
	private
		def	set_student
			@student = Student.find(params[:id])
		end

		def	student_params
			params.require(:student).permit(:name, :email, :password, :password_confirmation)
		end
end
