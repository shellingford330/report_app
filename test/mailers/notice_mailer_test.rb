require 'test_helper'

class NoticeMailerTest < ActionMailer::TestCase
  test "create_report" do
    student = students(:keiichi)
    mail = NoticeMailer.create_report(student)
    assert_equal "新しい指導報告書が作成されました", mail.subject
    assert_equal [student.email], mail.to
    assert_equal ["hirofumi0330@gmail.com"], mail.bcc
    assert_equal ["jiyujyuku@example.com"], mail.from
  end

end
