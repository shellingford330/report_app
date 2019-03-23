class NewsController < ApplicationController
  before_action :user_logged_in,    only:   [:student_index, :teacher_index, :show]
  before_action :teacher_logged_in, except: [:student_index, :teacher_index, :show]
  before_action :admin_logged_in,   only:   [:release, :draft]
  before_action :set_news,          only:   [:show, :edit, :release, :draft, :update, :destroy]
  before_action :correct_student_or_teacher, only: [:show]
  before_action :correct_teacher_or_admin,   only: [:edit, :destroy, :update]

  def student_index
    student = Student.find(params[:id])
    if teacher_logged_in?
      @news = student.news.paginate(page: params[:page], per_page: 9) 
    else
      @news = student.news.released.paginate(page: params[:page], per_page: 9) 
    end
    render 'index'
  end

  def teacher_index
    if admin_logged_in?
      @news = News.paginate(page: params[:page], per_page: 9) 
    else
      @news = News.where(teacher_id: params[:id]).paginate(page: params[:page], per_page: 9) 
    end
    render 'index'
  end

  def show
  end

  def select
		if (students_id = params[:students_id])
			@students_id = students_id.map { |i| i.to_i }
		else
			@students_id = []
		end
	end

  def new
    @news = News.new
    if params[:select] == "one"
      @news.students_id = [params[:students_id].to_i]
    else
      @news.students_id = params[:students_id]
    end
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
    redirect_to teacher_news_url(current_teacher)
  end

  def draft
    flash[:success] = "非公開にしました"
    @news.draft!
    @news.save
    redirect_to teacher_news_url(current_teacher)
  end

  def create
    @news = current_teacher.news.build(news_params)
    @news.students_id = params[:news][:students_id].split(' ').map { |id| id.to_i }
    students_exist?
    if @news.save
      @news.students_id.each do |student_id|
        Student.find(student_id).news << @news
      end
      redirect_to teacher_news_url(current_teacher)
      flash[:success] = '作成されました'
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

  private
    # 生徒が渡されているか？
    def students_exist?
      unless @news.students_id
        flash.now[:danger] = " 生徒が選択されていません"
        render 'select' and return
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
