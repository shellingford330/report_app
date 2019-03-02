class ReportsController < ApplicationController
  before_action :user_logged_in,    only: [:student_index, :teacher_index]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :release, :draft, :update, :destroy]
  before_action :admin_logged_in,   only: [:release, :draft]
  before_action :set_report,        only: [:show, :edit, :release, :draft, :update, :destroy]
  before_action :correct_teacher_or_admin,   only: [:edit, :update, :destroy]
  before_action :correct_student_or_teacher, only: [:show]

  def student_index
    @reports = current_student.reports.released.paginate(page: params[:page], per_page: 9)
    render 'index'
  end

  def teacher_index
    @reports = current_teacher.reports.paginate(page: params[:page], per_page: 9)
    render 'index'
  end

  def show
    @report.update(read_flg: true) if correct_student?(@report.student)
    @student = @report.student
    @teacher = @report.teacher
  end

  def new
    @report = Report.new(student_id: params[:student_id])
  end

  def edit
  end

  def release
    flash[:success] = "公開しました"
    @report.released!
    @report.save
    redirect_to @report
  end

  def draft
    flash[:success] = "非公開にしました"
    @report.draft!
    @report.save
    redirect_to @report
  end

  def create
    @report = current_teacher.reports.build(report_params)
    if @report.save
      flash[:success] = '報告書が作成されました'
      redirect_to @report
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'new'
    end
  end

  def update
    if @report.update(report_params)
      flash[:success] = '更新しました' 
      redirect_to @report
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'edit'
    end
  end

  def destroy
    @report.destroy
    flash[:success] = '削除されました'
    redirect_to teacher_reports_url
  end

  private
    def report_params
      params.require(:report).permit(:start_date, :end_date, :subject, :content, :homework, :comment, :memo, :student_id)
    end
    
    # before_action

    def set_report
      @report = Report.find(params[:id])
    end

    # ログインしているのが講師本人か、認証された講師か確認
    def correct_teacher_or_admin
      unless correct_teacher?(@report.teacher) || admin_logged_in?
        store_location
        redirect_to teachers_login_url
      end
    end

    # ログインしているのが生徒本人か、講師か確認
    def correct_student_or_teacher
      unless correct_student?(@report.student) || teacher_logged_in?
        store_location
        redirect_to students_login_path 
      end
    end
end
