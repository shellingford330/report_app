class NoticeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.create_report.subject
  #
  def create_report(student)
    @student = student
    mail to: Teacher.last.email,
      subject: '新しい指導報告書が作成されました'
  end
end
