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
    mail to: Teacher.admin.pluck(:email), subject: '保護者からお問い合わせが届きました'
  end

  # 渡されたお知らせの生徒に通知メール
  def create_news(news)
    @news = news
    @teacher = news.teacher
    student_emails = news.students.pluck(:email)
    mail to: student_emails, subject: 'お知らせが届きました'
  end

  # 渡された返信のユーザーに通知メール
  def create_reply(reply)
    @paper = reply.replyable
    @paper_name = @paper.class == Contact ? 'お問い合わせ' : '指導報告書'
    @sender = reply.writeable
    if reply.writeable_type == "Student"
      @receiver = Teacher.find(@paper.teacher_id)
      admin_emails = Teacher.where.not(status: 'teacher').pluck(:email)
      mail to: @receiver.email,
           bcc: admin_emails,
           subject: "#{@paper_name}にコメントされました"
    else
      @receiver = Student.find(@paper.student_id)
      mail to: @receiver.email, subject: "#{@paper_name}にコメントされました"
    end
  end
  

  # 生徒のメールアドレス確認メール
  def activate_account(student)
    @student = student
    mail to: @student.email, subject: "アカウントを有効化して下さい"
  end

  # 講師のメールアドレス確認メール
  def activate_teacher(teacher)
    @teacher = teacher
    mail to: @teacher.email, subject: "アカウントを有効化して下さい"
  end

  # 生徒がオーナーに承認依頼メール
  def authenticate_student(student)
    @student = student
    owner_emails = Teacher.owner.pluck(:email)
    mail to: owner_emails, subject: "生徒から登録依頼が届きました"
  end

  # 講師がオーナーに承認依頼メール
  def authenticate_teacher(teacher)
    @teacher = teacher
    owner_emails = Teacher.owner.pluck(:email)
    mail to: owner_emails, subject: "生徒から登録依頼が届きました"
  end
    

  # 渡された指導報告の生徒に通知メール
  def create_student(student)
    @student = student
    @owner_emails = Teacher.owner.pluck(:email)
    mail to:      @student.email,
         bcc:     @owner_emails,
         subject: '「okurun」に登録されました'
  end

  # 渡された指導報告の講師に通知メール
  def create_teacher(teacher)
    @teacher = teacher
    @owner_emails = Teacher.owner.pluck(:email)
    mail to:      @teacher.email,
         bcc:     @owner_emails,
         subject: '「okurun」に登録されました'
  end

  # パスワード再設定の本人確認メール
  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'パスワード再設定'
  end

end
