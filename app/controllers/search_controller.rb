class SearchController < ApplicationController
	before_action :teacher_logged_in

	def create
		@report = current_teacher.reports.build
		# 書いた講師を検索
		teachers = Teacher.where(id: (ids = params[:report][:teacher_id]))
		if teachers.exists?
			@reports = Report.where(teacher_id: ids)
		else
			@reports = Report.all
		end

		# 公開/非公開を検索
		unless params[:report][:status] == "all"
			@reports.where!(status: params[:report][:status])
		end

		# 返信が有る報告書を検索
		@reports_id = []
		if params[:reply] && (params[:reply][:exists] || (judge = params[:reply][:read_flg]))
			@reports = @reports.map do |report|
				if report.replies.where(writeable_type: "Student").exists?
					# 未読の返信を検索
					if judge
						if report.replies.where(writeable_type: "Student", read_flg: false).exists?
							report
						end
					else
						report
					end
				end
			end
			@reports.compact!
		end

		render 'edit_reports/index'
	end

end
