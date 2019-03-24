class MultiReportsController < ApplicationController
	before_action :teacher_logged_in, only: [:index, :new, :create, :new_mix]

	def index
		if (students_id = params[:students_id])
			@students_id = students_id.map { |i| i.to_i }
		else
			@students_id = []
		end
	end

	def new
		if (@students_id = params[:students_id])
			@report = Report.new
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

	def new_mix
		@students_id = params[:report][:student_id].split(' ').map { |id| id.to_i }
		@reports = []
		@students_id.each do |student_id|
			@report  = Report.new(params.require(:report).permit(:start_date, :end_date, :content, :homework, :comment, :memo))
			@report.student_id = student_id
			@report.subjects = params[:report][:subjects] 
			@reports.push(@report)
		end
		render 'new'
	end

	def create
		@reports = current_teacher.reports.build(report_params)
		@students_id = []
		judge = true
		@reports.each do |report|
			report.subjects = report.subject.split
			@students_id.push(report.student_id)
			judge = false unless report.save
		end
		if judge
			flash[:success] = '報告書が作成されました'
			redirect_to teacher_reports_url(current_teacher)
		else
			@report = Report.new
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
