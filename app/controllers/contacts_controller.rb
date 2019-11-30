class ContactsController < ApplicationController
  before_action :student_logged_in,        only: [:new, :create]

  def index
    if teacher_logged_in?
      @contacts = Contact.paginate(page: params[:page], per_page: 9)
    elsif student_logged_in?
      @contacts = current_student.contacts.paginate(page: params[:page], per_page: 9)
    else
      store_location
      redirect_to students_login_url
    end
  end

  def show
    @contact = Contact.find(params[:id])
    @reply = Reply.new
    if admin_logged_in?
      @contact.update(read_flg: true)
      @contact.replies.written_by("Student").update_all(read_flg: true)
    elsif correct_student?(@contact.student)
      @contact.replies.written_by("Teacher").update_all(read_flg: true)
    else
      store_location
      redirect_to students_login_url
    end
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = current_student.contacts.build(contact_params)
    if @contact.save
      NoticeMailer.create_contact(@contact).deliver_now
      redirect_to @contact
      flash[:success] = '作成されました'
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render :new
    end
  end

  def reply
    @contact = Contact.find(params[:id])

    # 管理者かお問い合わせを書いた生徒本人であるか確認
    unless admin_logged_in? || correct_student?(@contact.student)
      store_location
      redirect_to students_login_url and return
    end

    @reply = current_user.replies.build(content: params[:reply][:content])
    if @contact.replies << @reply
      @contact.touch                 # updated_atを更新
      @reply.send_create_reply_mail
      flash[:success] = "返信しました"
    end
    redirect_to @contact
  end

  private

    def contact_params
      params.require(:contact).permit(:title, :content, :teacher_id)
    end
end
