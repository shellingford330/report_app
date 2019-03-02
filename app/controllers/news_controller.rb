class NewsController < ApplicationController
  before_action :user_logged_in,    only:   [:index, :show]
  before_action :teacher_logged_in, except: [:index, :show]
  before_action :admin_logged_in,   only:   [:release, :draft]
  before_action :set_news,          only:   [:show, :edit, :release, :draft, :update, :destroy]
  before_action :correct_student_or_teacher, only: [:show]
  before_action :correct_teacher_or_admin,   only: [:edit, :destroy, :update]

  def index
    if admin_logged_in?
      @news = News.paginate(page: params[:page], per_page: 9)
    elsif teacher_logged_in?
      @news = News.released.paginate(page: params[:page], per_page: 9)
    else
      @news = current_student.news.released.paginate(page: params[:page], per_page: 9)
    end
  end

  def show
  end

  def select_students
  end

  def new
    @news = News.new
    @news.students_id = params[:students_id]
    students_exist?
  end

  def edit
    @news.students_id = @news.student_ids
    students_exist?
  end

  def release
    flash[:success] = "公開しました"
    @news.released!
    @news.save
    redirect_to news_index_url
  end

  def draft
    flash[:success] = "非公開にしました"
    @news.draft!
    @news.save
    redirect_to news_index_url
  end

  def create
    @news = current_teacher.news.build(news_params)
    @news.students_id = params[:news][:students_id].split(' ').map { |id| id.to_i }
    students_exist?
    if @news.save
      @news.students_id.each do |student_id|
        Student.find(student_id).news << @news
      end
      redirect_to news_index_url
      flash[:success] = '作成されました'
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'new'
    end
  end

  def update
    if @news.update(news_params)
      redirect_to news_index_url
      flash[:success] = '更新しました'
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'edit'
    end
  end

  def destroy
    @news.destroy
    redirect_to news_index_url
    flash[:success] = '削除しました'
  end

  private
    # 生徒が渡されているか？
    def students_exist?
      unless @news.students_id
        flash.now[:danger] = " 生徒が選択されていません"
        render 'select_students' and return
      end
    end

    def set_news
      @news = News.find(params[:id])
    end

    def news_params
      params.require(:news).permit(:title, :content)
    end

    # ログインしているのが生徒本人か、講師か確認
    def correct_student_or_teacher
      unless teacher_logged_in? || current_student.news.exists?(@news.id)
        store_location
        redirect_to teachers_login_url and return
      end
    end

    # ログインしているのが講師本人か、認証された講師か確認
    def correct_teacher_or_admin
      unless correct_teacher?(@news.teacher) || admin_logged_in?
        store_location
        redirect_to teachers_login_url and return
      end
    end
end
