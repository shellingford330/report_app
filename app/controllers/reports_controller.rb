class ReportsController < ApplicationController
  before_action :user_logged_in,    only: [:student_index, :teacher_index]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :release, :draft, :update, :destroy]
  before_action :admin_logged_in,   only: [:release, :draft]
  before_action :set_report,        only: [:show, :edit, :release, :draft, :update, :destroy, :reply]
  before_action :correct_teacher_or_admin,   only: [:edit, :update, :destroy]
  before_action :correct_student_or_teacher, only: [:show]
  before_action :correct_student_or_admin,   only: [:reply]

  def student_index
    if teacher_logged_in?
      @reports = Report.where(student_id: params[:id]).paginate(page: params[:page], per_page: 9)
    else
      @reports = Report.where(student_id: params[:id]).released.paginate(page: params[:page], per_page: 9)
    end
  end

  def teacher_index
    teacher = Teacher.find(params[:id])
    if admin_logged_in? && correct_teacher?(teacher)
      @reports = Report.paginate(page: params[:page], per_page: 16)
    else
      @reports = teacher.reports.paginate(page: params[:page], per_page: 16)
    end
  end

  def show
    @reply = Reply.new
    if student_logged_in?
      @report.update(read_flg: true)
      @report.replies.where(writeable_type: "Teacher").update_all(read_flg: true)
    elsif admin_logged_in?
      @report.replies.where(writeable_type: "Student").update_all(read_flg: true)
    end
  end

  def new
    @report = Report.new(student_id: params[:student_id])
  end

  def edit
    @report.subjects = @report.subject.split 
  end

  def release
    flash[:success] = "公開しました"
    @report.released!
    @report.save
    redirect_to teacher_reports_url(current_teacher)
  end

  def draft
    flash[:success] = "非公開にしました"
    @report.draft!
    @report.save
    redirect_to teacher_reports_url(current_teacher)
  end

  def create
    @report = current_teacher.reports.build(report_params)
    @report.subject = params[:report][:subjects].join(" ")
    if @report.save
      flash[:success] = '報告書が作成されました'
      redirect_to @report
    else
      @report.subjects = @report.subject.split
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'new'
    end
  end

  def update
    @report.subject = params[:report][:subjects].join(" ")
    if @report.update(report_params)
      flash[:success] = '更新しました' 
      redirect_to @report
    else
      @report.subjects = @report.subject.split
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'edit'
    end
  end

  def destroy
    @report.destroy
    flash[:success] = '削除されました'
    redirect_to teacher_reports_url(current_teacher)
  end

  def reply
    if student_logged_in?
      @reply = current_student.replies.build(content: params[:reply][:content])
    else
      @reply = current_teacher.replies.build(content: params[:reply][:content])
    end
    @report.replies << @reply
    flash[:success] = "返信しました"
    redirect_to @report
  end

  private
    def report_params
      params.require(:report).permit(:start_date, :end_date, :content, :homework, :comment, :memo, :student_id)
    end
    
    # before_action

    def set_report
      @report = Report.find(params[:id])
    end

    # ログインしているのが講師本人か、認証された講師か確認
    def correct_teacher_or_admin
      unless correct_teacher?(@report.teacher) || admin_logged_in?
        store_location
        redirect_to teachers_login_url and return
      end
    end

    # ログインしているのが生徒本人か、講師か確認
    def correct_student_or_teacher
      unless correct_student?(@report.student) || teacher_logged_in?
        store_location
        redirect_to students_login_path and return
      end
    end

    # ログインしているのが生徒本人か、管理者か確認
    def correct_student_or_admin
      unless correct_student?(@report.student) || admin_logged_in?
        store_location
        redirect_to students_login_path and return
      end
    end
end
