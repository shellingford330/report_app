class NewsController < ApplicationController
  before_action :teacher_logged_in,          only: [:select, :new, :create]
  before_action :set_news,                   only: [:show, :release, :file, :destroy]

  def student
    student = Student.find(params[:id])
    if teacher_logged_in?
      @news = student.news.paginate(page: params[:page], per_page: 9) 
    elsif correct_student?(student)
      @news = student.news.released.paginate(page: params[:page], per_page: 9) 
    else
      store_location
      redirect_to root_url
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
      redirect_to login_form_teachers_url
    end
  end

  def show
    @students = @news.students
    # ログインしているのが生徒本人か、講師か確認
    unless teacher_logged_in? || @students.exists?(current_student)
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

  def create
    @news = current_teacher.news.build(news_params)
    @news.student_ids = params[:news][:student_ids]
    if @news.save
      flash[:success] = '作成されました'
      redirect_to teacher_news_url(current_teacher)
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'new'
    end
  end

  def destroy
    # ログインしているのが講師本人か、認証された講師か確認
    if correct_teacher?(@news.teacher) || admin_logged_in?
      @news.destroy
      redirect_to teacher_news_url(current_teacher)
      flash[:success] = '削除しました'
    else
      store_location
      redirect_to login_form_teachers_url and return
    end
  end

  def release
    admin_logged_in
    @news.released!
    flash[:success] = "公開しました"
    NoticeMailer.create_news(@news).deliver_later
    redirect_to teacher_news_url(current_teacher)
  end

  def file
    user_logged_in
    if @news.upfile?
      data = open(URI.encode(@news.upfile.url))
      send_data data.read, disposition: 'attachment', filename: @news.upfile.identifier
    else
      flash[:danger] = "ファイルが存在しません"
      redirect_back fallback_location: { action: :show }
    end
  end

  private
    def set_news
      @news = News.find(params[:id])
    end

    def news_params
      params.require(:news).permit(:title, :content, :upfile, :upfile_cache)
    end
end
