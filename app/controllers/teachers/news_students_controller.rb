# frozen_string_literal: true

module Teachers
	class NewsStudentsController < Teachers::BaseController
		def show
			@news    = News.find(params[:news_id])
			@student = @news.students.find(params[:id])
			@reply   = @news.replies.build # form用
			@replies = @news.replies.where(student: @student).order(id: :asc)

			# 生徒のリプライをすべて既読にする
			if current_teacher.admin?
				@news.replies.from_student.where(student: @student).update_all(is_read: true)
			end
		end
	end
end