require 'test_helper'

class StudentsLoginTest < ActionDispatch::IntegrationTest
  def setup
    @student = students(:keiichi)
  end

  test "flash should be empty after redirecting" do
    get '/students/login'
    assert_template 'students/login_form'
    post '/students/login', params: { student: { email: "", password: "" } }
    assert_not flash.empty?
    get '/students/login'
    assert flash.empty?
  end

  test "login with valid information" do
    get students_login_path
    post students_login_path, params: { student:  { email: @student.email,
                                                    password: "keiichi" } }
    assert_redirected_to @student
    follow_redirect!
    assert_template 'students/show'
  end
end
