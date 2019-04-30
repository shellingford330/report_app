class NoticeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.create_report.subject
  #

  # 渡された指導報告の生徒に通知メール
  def create_report(report)
    @report = report
    @student = report.student
    mail to: @student.email, subject: '新しい指導報告書が作成されました'
  end

  # 渡されたお問い合わせの講師に通知メール
  def create_contact(contact)
    @contact = contact
    @student = contact.student
    @teacher = contact.teacher
    mail to: @teacher.email, subject: '保護者からお問い合わせが届きました'
  end

  # 渡された返信されたユーザーにメール
  def create_reply(reply)
    @paper = reply.replyable
    @paper_name = @paper.class == Contact ? 'お問い合わせ' : '指導報告書'
    @sender = reply.writeable
    @receiver = reply.writeable_type == "Student" ? Teacher.find_by(id: @paper.teacher_id) : Student.find_by(id: @paper.student_id)
    mail to: @receiver.email, subject: "#{@paper_name}にコメントされました"
  end
  
  # 渡された指導報告の生徒に通知メール
  def create_student(student)
    @student = student
    mail to:      @student.email,
         bcc:     'hirofumi0330@gmail.com',
         subject: '自由塾に生徒登録されました'
  end

  # 渡された指導報告の講師に通知メール
  def create_teacher(teacher)
    @teacher = teacher
    mail to:      @teacher.email,
         bcc:     'hirofumi0330@gmail.com',
         subject: '自由塾に講師登録されました'
  end

end
