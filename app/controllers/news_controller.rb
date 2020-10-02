class NewsController < ApplicationController
  before_action :teacher_logged_in, only: [:select, :new, :create, :destroy, :release]
  before_action :student_logged_in, only: [:index, :show, :reply]
  before_action :set_news,          only: [:release, :file, :destroy]

  def index
    @news = current_student.news.released.paginate(page: params[:page], per_page: 9) 
  end

  def show
    @news    = current_student.news.released.find(params[:id])
    @reply   = @news.replies.build # form用
    @replies = @news.replies.where(student: current_student)

    # 講師のリプライをすべて既読にする
    @news.replies.from_teacher.where(student: current_student).update_all(is_read: true)
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
      redirect_to teachers_news_url(@news)
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'new'
    end
  end

  def destroy
    # ログインしているのが講師本人か、認証された講師か確認
    if correct_teacher?(@news.teacher) || admin_logged_in?
      @news.destroy
      redirect_to teachers_news_index_path
      flash[:success] = '削除しました'
    else
      store_location
      redirect_to login_form_teachers_url and return
    end
  end

  def reply
    @news = current_student.news.released.find(params[:id])

    @reply = @news.replies.build do |reply|
      reply.content = params[:news_reply][:content]
      reply.student = current_student
      reply.teacher = @news.teacher # 生徒はお知らせを書いた講師にリプライしている前提
      reply.sender_type = "student"
    end

    if @reply.save
      NoticeMailer.send_news_reply_from_student(@reply).deliver_now
      flash[:success] = "返信しました"
    else
      flash[:danger] = "返信に失敗しました"
    end
    redirect_to @news
  end

  def release
    admin_logged_in
    @news.released!
    flash[:success] = "公開しました"
    NoticeMailer.create_news(@news).deliver_later
    redirect_to teachers_news_url(@news)
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
