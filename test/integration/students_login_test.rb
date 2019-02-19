require 'test_helper'

class StudentsLoginTest < ActionDispatch::IntegrationTest
  def setup
    @student = students(:keiichi)
  end

  test "flash should be empty after redirecting" do
    get '/students/login'
    assert_select "a[href=?]", students_logout_path, count: 0
    assert_template 'students/login_form'
    post '/students/login', params: { student: { email: "", password: "" } }
    assert_not flash.empty?
    get '/students/login'
    assert flash.empty?
  end

  test "login with valid information" do
    get students_login_path
    assert_select "a[href=?]", edit_student_path(@student), count: 0
    post students_login_path, params: { student:  { email: @student.email,
                                                    password: "keiichi" } }
    assert student_is_logged_in?
    assert_redirected_to @student
    follow_redirect!
    assert_template 'students/show'
  end

  test "login with valid information followed by logout" do
    get students_login_path
    post students_login_path, params: { student:  { email: @student.email,
                                                    password: "keiichi" } }
    delete students_logout_path
    assert_not student_is_logged_in?
    delete students_logout_path
    assert_redirected_to students_login_path
    follow_redirect!
    assert_select "a[href=?]", students_logout_path, count: 0
    assert_select "a[href=?]", edit_student_path(@student), count: 0
  end

  test "login with remember me" do
    get students_login_path
    post students_login_path, params: { student:  { email: @student.email,
                                                    password: "keiichi" } ,
                                        remember_me: 'yes' }
    assert_not_empty cookies['remember_token']
  end
  
  test "login with not remember me" do
    get students_login_path
    post students_login_path, params: { student:  { email: @student.email,
                                                    password: "keiichi" } ,
                                        remember_me: 'yes' }
    assert student_is_logged_in?
    delete students_logout_path
    assert_not student_is_logged_in?
    assert_empty cookies['remember_token']
    post students_login_path, params: { student:  { email: @student.email,
                                                    password: "keiichi" } ,
                                        remember_me: 'no' }
    assert_empty cookies['remember_token']
  end

  test "students cant create and delete and index themselves" do
    get students_login_path
    post students_login_path, params: { student:  { email: @student.email,
                                                    password: "keiichi" } ,
                                        remember_me: 'yes' }
    assert student_is_logged_in?
    get students_path
    assert_redirected_to teachers_login_path
    get new_student_path
    assert_redirected_to teachers_login_path
  end
end
