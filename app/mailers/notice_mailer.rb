# frozen_string_literal: true

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

  # 管理者・オーナーにお問い合わせの通知メール
  def create_contact(contact)
    @contact = contact
    @student = contact.student
    mail to: Teacher.admin.pluck(:email), subject: '保護者からお問い合わせが届きました'
  end

  # お知らせの生徒に通知メール
  def create_news(news)
    @news = news
    @teacher = news.teacher
    student_emails = news.students.pluck(:email)
    mail to: @teacher.email, bcc: student_emails, subject: 'お知らせが届きました'
  end

  # 返信が届いたユーザーに通知メール
  def create_reply(reply)
    # 返信先の媒体(お問い合わせ, 指導報告書)
    @doc = reply.replyable
    @kind_of_doc = @doc.is_a?(Contact) ? 'お問い合わせ' : '指導報告書'
    # 返信をしたユーザー
    @sender = reply.writeable.name
    @kind_of_sender = reply.writeable.is_a?(Student) ? '生徒' : '自由塾'
    # 返信が届いたユーザー
    if @kind_of_sender == '生徒'
      @receiver = "自由塾"
      mail to: Teacher.admin.pluck(:email),
           subject: "#{@kind_of_doc}に返信が届きました"
    else
      student = Student.find(@doc.student_id)
      @receiver = student.name
      mail to: student.email, subject: "#{@kind_of_doc}に返信が届きました"
    end
  end

  def send_news_reply_from_student(news_reply)
    @reply = news_reply
    mail to: Teacher.admin.pluck(:email),
         subject: "お知らせに生徒から返信が届きました"
  end

  def send_news_reply_from_teacher(news_reply)
    @reply = news_reply
    mail to: @reply.student.email,
         subject: "お知らせに自由塾から返信が届きました"
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
    mail to: owner_emails, subject: "生徒の登録依頼が届きました"
  end

  # 講師がオーナーに承認依頼メール
  def authenticate_teacher(teacher)
    @teacher = teacher
    owner_emails = Teacher.owner.pluck(:email)
    mail to: owner_emails, subject: "講師の登録依頼が届きました"
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
