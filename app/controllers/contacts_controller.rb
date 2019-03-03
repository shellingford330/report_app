class ContactsController < ApplicationController
  before_action :user_logged_in,    only:   [:index, :show]
  before_action :student_logged_in, except: [:index, :show]
  before_action :set_contact,       only:   [:show, :edit, :update, :destroy]
  before_action :set_admin,         only:   [:new, :edit, :create, :update]
  before_action :correct_student_and_teacher_or_admin, only: [:show]
  before_action :correct_student,   only:   [:edit, :update, :destroy]

  def index
    if admin_logged_in?
      @contacts = Contact.paginate(page: params[:page], per_page: 9)
    elsif teacher_logged_in?
      @contacts = current_teacher.contacts.paginate(page: params[:page], per_page: 9)
    else
      @contacts = current_student.contacts.paginate(page: params[:page], per_page: 9)
    end
  end

  def show
  end

  def new
    @contact = Contact.new
  end

  def edit
  end

  def create
    @contact = current_student.contacts.build(contact_params)
    if @contact.save
      redirect_to @contact
      flash[:success] = '作成されました'
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render :new
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to @contact
      flash[:success] = '更新されました'
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render :edit
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_url
    flash[:success] = '削除されました'
  end

  private

    def set_contact
      @contact = Contact.find(params[:id])
    end

    # 認証された講師をセット
    def set_admin
      @admin = Teacher.where(status: "manager").or(Teacher.where(status: "owner")).select(:id, :name)
    end

    def contact_params
      params.require(:contact).permit(:title, :content, :teacher_id)
    end

    # ログインしているのが生徒本人か講師本人か管理者か確認
    def correct_student_and_teacher_or_admin
      unless admin_logged_in? || correct_student?(@contact.student) || correct_teacher?(@contact.teacher)
        store_location
        redirect_to students_login_url and return
      end
    end

    # ログインしているのが生徒本人か確認
    def correct_student
      unless correct_student?(@contact.student)
        store_location
        redirect_to students_login_url and return
      end
    end
end
