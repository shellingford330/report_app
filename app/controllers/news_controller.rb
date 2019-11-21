class NewsController < ApplicationController
  before_action :teacher_logged_in,          only: [:select, :new, :create]
  before_action :admin_logged_in,            only: [:release, :draft]
  before_action :set_news,                   only: [:show, :edit, :release, :draft, :update, :destroy]
  before_action :correct_teacher_or_admin,   only: [:edit, :destroy, :update]

  def student
    student = Student.find(params[:id])
    if teacher_logged_in?
      @news = student.paginate(page: params[:page], per_page: 9) 
    elsif correct_student?(student)
      @news = student.news.released.paginate(page: params[:page], per_page: 9) 
    else
      store_location
      redirect_to students_login_url
    end
  end

  def teacher
    teacher = Teacher.find(params[:id])
    if admin_logged_in?
      @news = News.paginate(page: params[:page], per_page: 16) 
    elsif teacher_logged_in?
      @news = teacher.news.paginate(page: params[:page], per_page: 16)
    else
      store_location
      redirect_to students_login_url
    end
  end

  def show
    # ログインしているのが生徒本人か、講師か確認
    unless teacher_logged_in? || current_student.news.exists?(@news.id)
      store_location
      redirect_to login_form_teachers_url and return
    end
  end

  def select
    @news = News.new
    @news.student_ids = params[:student_ids]
	end

  def new
    @news = News.new
    @news.student_ids = params[:student_ids]
    if @news.student_ids.empty?
      flash.now[:danger] = " 生徒が選択されていません"
      render 'select'
    else
      render 'new'
    end
  end

  def edit
  end

  def create
    @news = current_teacher.news.build(news_params)
    @news.student_ids = params[:news][:student_ids].split
    if @news.save
      NoticeMailer.create_news(@news).deliver_later
      flash[:success] = '作成されました'
      redirect_to teacher_news_url(current_teacher)
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'new'
    end
  end

  def update
    if @news.update(news_params)
      redirect_to teacher_news_url(current_teacher)
      flash[:success] = '更新しました'
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'edit'
    end
  end

  def destroy
    @news.destroy
    redirect_to teacher_news_url(current_teacher)
    flash[:success] = '削除しました'
  end

  def release
    flash[:success] = "公開しました"
    @news.released!
    @news.save
    redirect_to teacher_news_url(current_teacher)
  end

  def draft
    flash[:success] = "非公開にしました"
    @news.draft!
    @news.save
    redirect_to teacher_news_url(current_teacher)
  end

  private
    def set_news
      @news = News.find(params[:id])
    end

    def news_params
      params.require(:news).permit(:title, :content)
    end

    # ログインしているのが講師本人か、認証された講師か確認
    def correct_teacher_or_admin
      unless correct_teacher?(@news.teacher) || admin_logged_in?
        store_location
        redirect_to login_form_teachers_url and return
      end
    end
end
