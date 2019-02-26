class ReportsController < ApplicationController
  before_action :teacher_logged_in, only: [:new, :create, :edit, :release, :draft, :update, :destroy]
  before_action :admin_logged_in,   only: [:release, :draft]
  before_action :set_report,        only: [:show, :edit, :release, :draft, :update, :destroy]
  before_action :correct_teacher_or_admin, only: [:edit, :update, :destroy]

  def index
    user_logged_in
    @reports = Report.paginate(page: params[:page], per_page: 9)
  end

  def show
		redirect_to students_login_path unless correct_student?(@report.student) || teacher_logged_in?
  end

  def new
    @report = Report.new
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
    @report = Report.new(report_params)

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
      flash[:success] = 'Report was successfully updated.' 
      redirect_to @report
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'edit'
    end
  end

  def destroy
    @report.destroy
    flash[:success] = '削除されました'
    redirect_to reports_url
  end

  private
    def report_params
      params.require(:report).permit(:start_date, :end_date, :subject, :content, :homework, :comment, :memo, :student_id, :teacher_id)
    end
    
    def set_report
      @report = Report.find(params[:id])
    end

    def admin_logged_in
      redirect_to teachers_login_url unless admin_logged_in?
    end

    def correct_teacher_or_admin
      unless correct_teacher?(@report.teacher) || admin_logged_in?
        redirect_to teachers_login_url
      end
    end
end
