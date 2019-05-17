# Preview all emails at http://localhost:3000/rails/mailers/notice_mailer
class NoticeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/create_report
  def create_report
    report = Report.first
    NoticeMailer.create_report(report)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/create_contact
  def create_contact
    contact = Contact.first
    NoticeMailer.create_contact(contact)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/create_news
  def create_news
    news = News.first
    NoticeMailer.create_news(news)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/create_reply
  def create_reply
    reply = Reply.first
    NoticeMailer.create_reply(reply)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/activate_account
  def activate_account
    student = Student.first
    student.activation_token = Student.new_token
    NoticeMailer.activate_account(student)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/authenticate_student
  def authenticate_student
    student = Student.first
    student.activation_token = Student.new_token
    NoticeMailer.authenticate_student(student)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/create_student
  def create_student
    student = Student.first
    NoticeMailer.create_student(student)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/create_teacher
  def create_teacher
    teacher = Teacher.first
    NoticeMailer.create_teacher(teacher)
  end

end
