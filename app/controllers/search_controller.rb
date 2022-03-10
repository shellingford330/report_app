# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :teacher_logged_in

  def index
    @search_reports_form = SearchReportsForm.new(
      status: params[:search_reports_form][:status],
      teacher_ids: params[:search_reports_form][:teacher_ids],
    )
    # 書いた講師を検索
    teachers = Teacher.where(id: @search_reports_form.teacher_ids)
    @reports = if teachers.exists?
                 Report.where(teacher: teachers)
               else
                 Report.all
               end

    # 公開/非公開を検索
    @reports.where!(status: @search_reports_form.status) unless @search_reports_form.status == "all"

    @reports = @reports.page(params[:page]).per(15)
    @reports_id = []
    render 'edit_reports/index'
  end
end
