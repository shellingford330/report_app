class TeachersController < ApplicationController
  before_action :initialize_teacher, only: [:new, :login_form]
  before_action :set_teacher,        only: [:show, :edit, :update, :destroy]
  before_action :new_teacher,        only: [:create, :login]
  def index
    @teachers = Teacher.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @teacher.save
      redirect_to @teacher
      flash[:success] =  '講師を作成しました' 
    else
      flash.now[:danger] = "失敗しました"
      render 'new'
    end
  end

  
  def update
    if @teacher.update(teacher_params)
      redirect_to @teacher
      flash[:success] =  'Teacher was successfully updated.'
    else
      flash.now[:danger] = "入力情報をご確認下さい"
      render 'edit'
    end
  end

  def destroy
    @teacher.destroy
    redirect_to teachers_url
    flash[:success] = '講師を削除しました'
  end

  def login_form
  end

  def login
    teacher = Teacher.find_by(email: params[:teacher][:email].downcase)
		if teacher && teacher.authenticate(params[:teacher][:password])
      flash[:notice] = "ログインしました"
      teacher_log_in(teacher)
      params[:remember_me] == 'yes' ? remember_teacher(teacher) : forget_teacher(teacher)
			redirect_back_to teacher
		else
			flash.now[:danger] = "入力情報をご確認下さい"
			render 'login_form'
		end
  end

  def logout
    teacher_log_out if teacher_logged_in?
    redirect_to teachers_login_path
  end

  private
    def teacher_params
      params.require(:teacher).permit(:name, :email, :status, :password, :password_confirmation)
    end

    # before_action
    def initialize_teacher
      @teacher = Teacher.new
    end

    def new_teacher
      @teacher = Teacher.new(teacher_params)
    end

    def set_teacher
      @teacher = Teacher.find(params[:id])
    end
end
