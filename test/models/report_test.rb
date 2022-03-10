# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @student = students(:keiichi)
    @teacher = teachers(:owner)
    @report = @student.reports.build(start_date: Date.today, end_date: Date.tomorrow, status: 1, read_flg: false,
                                     teacher_id: @teacher.id,)
  end

  test "report should be valid" do
    assert @report.valid?
  end

  test "student_id and teacher_id should be present" do
    @report.student_id = nil
    assert @report.invalid?
    @report.student_id = @student.id
    @report.teacher_id = nil
    assert @report.invalid?
  end

  test "report should always order desc" do
    assert_equal reports(:most_recent), Report.first
  end
end
