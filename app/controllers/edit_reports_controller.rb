# frozen_string_literal: true

class EditReportsController < ApplicationController
  before_action :teacher_logged_in

  # 報告書編集ページの報告書の一覧表示
  def index
    @search_reports_form = SearchReportsForm.new(status: "all")
    @reports = Report.page(params[:page]).per(15)
    @reports_id = if (reports_id = params[:reports_id])
                    reports_id.map(&:to_i)
                  else
                    []
                  end
  end

  # 選択した報告書のデータを取得、表示
  def new
    if (@reports_id = params[:reports_id])
      # ログインしているのが講師本人か、管理者でないと編集できない
      @reports = if admin_logged_in?
                   Report.where(id: @reports_id)
                 else
                   current_teacher.reports.where(id: @reports_id)
                 end
      @reports.each(&:array_subject)
    else
      flash[:danger] = " 報告書が選択されていません"
      redirect_to edit_reports_url
    end
  end

  # 報告書を更新
  def create
    @reports = []
    @reports_id = []
    judge = true
    params.require(:report).each do |report_id, value|
      # ログインしている講師が本人か、管理者でないと編集できない
      if admin_logged_in?
        report = Report.find(report_id)
        report.send_create_report_mail if value[:status] == "released" && report.status == "draft"
        report.status = value[:status]
      else
        report = current_teacher.reports.find(report_id)
      end
      report.subjects = value[:subjects]
      report.subject = report.subjects.join(" ")
      judge = false unless report.update(value.permit(:start_date, :end_date, :content, :homework, :comment, :memo, :student_id))
      @reports_id.push(report_id.to_i)
      @reports.push(report)
    end
    if judge
      flash[:success] = '報告書が更新されました'
      redirect_to teacher_report_url(current_teacher)
    else
      flash.now[:danger] = '入力情報をご確認下さい'
      render 'new'
    end
  end
end
