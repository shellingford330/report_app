class EditReportsController < ApplicationController
	before_action :teacher_logged_in

	def index
		@report = current_teacher.reports.build
		if admin_logged_in?
			@reports = Report.all
		else
			@reports = current_teacher.reports.all
		end
		if (reports_id = params[:reports_id])
			@reports_id = reports_id.map { |i| i.to_i }
		else
			@reports_id = []
		end
	end

	def new
		if (@reports_id = params[:reports_id])
			@reports = Report.where(id: @reports_id)
			@reports.each do |report|
				report.subjects = report.subject.split
			end
		else
			flash[:danger] = " 報告書が選択されていません"
			redirect_to edit_reports_url
		end
	end

	def create
		@reports = []
		@reports_id = []
		judge = true
		params.require(:report).each do |report_id, value|
			report = Report.find(report_id)
			report.subjects = value[:subjects]
			report.status = value[:status] if admin_logged_in?
			report.subject = report.subjects.join(" ")
			judge = false unless report.update(value.permit(:start_date, :end_date, :content, :homework, :comment, :memo, :student_id))
			@reports_id.push(report_id.to_i)
			@reports.push(report)
		end
		if judge
			flash[:success] = '報告書が更新されました'
			redirect_to teacher_reports_url(current_teacher)
		else
			flash.now[:danger] = '入力情報をご確認下さい'
			render 'new'
		end
	end

end
