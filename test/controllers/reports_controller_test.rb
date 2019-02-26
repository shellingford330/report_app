require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report = reports(:one)
  end

  test "should get index" do
    get reports_url
    assert_redirected_to students_login_url
  end

  test "should get new" do
    get new_report_url
    assert_redirected_to teachers_login_url
  end

  test "should create report" do
    assert_difference('Report.count', 0) do
      post reports_url, params: { report: { comment: @report.comment, content: @report.content, end_date: @report.end_date, homework: @report.homework, memo: @report.memo, read_flg: @report.read_flg, start_date: @report.start_date, status: @report.status, student_id: @report.student_id, subject: @report.subject, teacher_id: @report.teacher_id } }
    end

    assert_redirected_to teachers_login_url
  end

  test "should show report" do
    get report_url(@report)
    assert_redirected_to students_login_url
  end

  test "should get edit" do
    get edit_report_url(@report)
    assert_redirected_to teachers_login_url
  end

  test "should update report" do
    patch report_url(@report), params: { report: { comment: @report.comment, content: @report.content, end_date: @report.end_date, homework: @report.homework, memo: @report.memo, read_flg: @report.read_flg, start_date: @report.start_date, status: @report.status, student_id: @report.student_id, subject: @report.subject, teacher_id: @report.teacher_id } }
    assert_redirected_to teachers_login_url
  end

  test "should destroy report" do
    assert_difference('Report.count', 0) do
      delete report_url(@report)
    end

    assert_redirected_to teachers_login_url
  end

end
