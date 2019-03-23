class MultiReportsController < ApplicationController
	before_action :teacher_logged_in, only: [:index, :new, :create]

	def index
		if (students_id = params[:students_id])
			@students_id = students_id.map { |i| i.to_i }
		else
			@students_id = []
		end
	end

	def new
		if (@students_id = params[:students_id])
			@reports = []
			@students_id.each do |student_id|
				report  = Report.new(student_id: student_id)
				report.start_date = Date.today
				report.homework = "学習記録をご覧下さい。"
				@reports.push(report)
			end
		else
			flash[:danger] = " 生徒が選択されていません"
			redirect_to multi_reports_url
		end
	end

	def create
		@reports = current_teacher.reports.build(report_params)
		judge = true
		@reports.each do |report|
			report.subjects = report.subject.split
			judge = false unless report.save
		end
		if judge
			flash[:success] = '報告書が作成されました'
			redirect_to teacher_reports_url(current_teacher)
		else
			flash.now[:danger] = '入力情報をご確認下さい'
			render 'new'
		end
	end

	private
		def report_params
			params.require(:report).map do |i|
				i[:subject] = i[:subjects].join(" ")
				i.permit(:start_date, :end_date, :subject, :content, :homework, :comment, :memo, :student_id)
			end
		end
end
