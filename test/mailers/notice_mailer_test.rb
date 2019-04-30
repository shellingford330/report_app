require 'test_helper'

class NoticeMailerTest < ActionMailer::TestCase
  test "create_report" do
    report = reports(:one)
    mail = NoticeMailer.create_report(report)
    assert_equal "新しい指導報告書が作成されました", mail.subject
    assert_equal [report.student.email], mail.to
    assert_equal ["jiyujyuku@example.com"], mail.from
  end

  test "create_student" do
    student = students(:keiichi)
    mail = NoticeMailer.create_student(student)
    assert_equal "生徒登録されました", mail.subject
    assert_equal [student.email], mail.to
  end

end
