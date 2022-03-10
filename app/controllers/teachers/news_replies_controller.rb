# frozen_string_literal: true

module Teachers
  class NewsRepliesController < Teachers::BaseController
    before_action :admin_logged_in, only: [:create]

    def create
      @news    = News.find(params[:news_id])
      @student = @news.students.find(params[:student_id])
      @replies = @news.replies.preload(:student, :teacher)

      @reply = @news.replies.build do |reply|
        reply.content     = params[:news_reply][:content]
        reply.teacher     = current_teacher
        reply.student     = @student
        reply.sender_type = "teacher"
      end

      if @reply.save
        NoticeMailer.send_news_reply_from_teacher(@reply).deliver_now
        flash[:success] = "返信しました"
      else
        flash[:danger] = "返信に失敗しました"
      end
      redirect_to teachers_news_student_path(@news, @student)
    end
  end
end
