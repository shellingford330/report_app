# Preview all emails at http://localhost:3000/rails/mailers/notice_mailer
class NoticeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/create_report
  def create_report
    student = Student.first
    NoticeMailer.create_report(student)
  end

end
