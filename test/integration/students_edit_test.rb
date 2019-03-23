require 'test_helper'

class StudentsEditTest < ActionDispatch::IntegrationTest
  def setup
    @student = students(:keiichi)
    @other_student = students(:kai)
  end

  test "edit with invalid" do
    post students_login_path, params: { student: { email: @student.email,
                                             password: "keiichi"}}
    assert student_is_logged_in?
    get edit_student_path(@student)
    assert_template 'students/edit'
    patch student_path(@student), params: { student: { name: "",
                                                       lesson_days: ["月"],
                                                       email: "st@example",
                                                       password: "foo",
                                                       password_confirmation: "bar" } }
    assert_not flash.empty?
    assert_template 'students/edit'
  end

  test "edit with valid and no password" do
    post students_login_path, params: { student: { email: @student.email,
                                             password: "keiichi"}}
    assert student_is_logged_in?
    get edit_student_path(@student)
    name = "exapmle"
    email = "st@example.com"
    patch student_path(@student), params: { student: { name: name,
                                                       lesson_days: ["月"],
                                                       email: email,
                                                       password: "",
                                                       password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @student
    follow_redirect!
    assert_template 'students/show'
    @student.reload
    assert_equal name, @student.name
    assert_equal email, @student.email
  end

  test "should redirect to login_form with no login" do
    get edit_student_path(@student)
    assert_redirected_to students_login_path
    name = "exapmle"
    email = "st@example.com"
    patch student_path(@student), params: { student: { name: name,
                                                       email: email,
                                                       password: "",
                                                       password_confirmation: "" } }
    assert_redirected_to students_login_path
  end

  test "correct student only edit" do
    post students_login_path, params: { student: { email: @other_student.email,
                                             password: "kai"}}
    assert student_is_logged_in?
    get edit_student_path(@student)
    assert_redirected_to @other_student
  end

  test "correct student only update" do
    post students_login_path, params: { student: { email: @other_student.email,
                                             password: "kai"}}
    assert student_is_logged_in?
    patch student_path(@student), params: { student: { name: "name",
                                                       email: "foo@ex.com" } }
    assert_redirected_to @other_student
  end

  test "success friendly forwarding" do
    get edit_student_path(@student)
    post students_login_path, params: { student: { email: @student.email,
                                                   password: "keiichi" } }
    assert_redirected_to edit_student_path(@student)
  end
end
