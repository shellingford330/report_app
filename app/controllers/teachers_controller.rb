class TeachersController < ApplicationController
  before_action :teacher_already_logged_in, only: [:login_form, :login]
  before_action :teacher_logged_in,  only: [:index ,:new, :create, :show, :edit, :update, :destroy]
  before_action :correct_teacher,    only: [:edit, :update]
  before_action :owner_logged_in,    only: [:new, :create, :auth, :destroy]
  before_action :initialize_teacher, only: [:new, :login_form]
  before_action :new_teacher,        only: [:create, :login]
  before_action :set_teacher,        only: [:show, :edit, :update, :auth, :destroy]
  def index
    @teachers = Teacher.paginate(page: params[:page], per_page: 10)
  end

  def show
    @reports = @teacher.reports.paginate(page: params[:page], per_page: 5)
  end

  def new
  end

  def edit
  end

  def auth
    @teacher.update(status: params[:teacher][:status])
    redirect_to @teacher
    flash[:notice] = "権限を変更しました"
  end

  def create
    if @teacher.save
      redirect_to @teacher
      flash[:success] =  '講師が作成されました' 
    else
      flash.now[:danger] = "失敗しました"
      render 'new'
    end
  end

  
  def update
    if @teacher.update(teacher_params)
      redirect_to @teacher
      flash[:success] =  '更新しました'
    else
      flash.now[:danger] = "入力情報をご確認下さい"
      render 'edit'
    end
  end

  def destroy
    @teacher.destroy
    flash[:success] = '講師が削除されました'
    redirect_to teachers_url
  end

  def login_form
    render layout: 'login' 
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
      render 'login_form', layout: 'login'
		end
  end

  def logout
    teacher_log_out if teacher_logged_in?
    redirect_to teachers_login_url
  end

  private
    def teacher_params
      params.require(:teacher).permit(:name, :email, :password, :password_confirmation)
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

    # ログインを既にしているか確認
		def teacher_already_logged_in
			if teacher_logged_in?
				redirect_to current_teacher
			end
		end
    
    # ログインしている講師であるか確認
		def correct_teacher
			@teacher = Teacher.find(params[:id])
			redirect_to current_teacher unless correct_teacher?(@teacher)
    end
    
end
