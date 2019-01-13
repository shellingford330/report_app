require 'test_helper'

class StudentsHelperTest < ActionView::TestCase

  def setup
    @student = students(:keiichi)
    remember_student(@student)
  end

  test "current_student returns right user when session is nil" do
    assert_equal @student, current_student
    assert student_is_logged_in?
  end

  test "current_student returns nil when remember digest is wrong" do
    @student.update_attribute(:remember_digest, Student.digest(Student.new_token))
    assert_nil current_student
  end
end