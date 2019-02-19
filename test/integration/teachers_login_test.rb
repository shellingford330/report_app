require 'test_helper'

class TeachersLoginTestTest < ActionDispatch::IntegrationTest
  def setup 
    @teacher = teachers(:owner)
  end

  test "teacher login with valid infomation" do
    get teachers_login_path
    post teachers_login_path, params: { teacher: { email: @teacher.email, password: 'jiyujyuku' } }
    assert_not session[:teacher_id].nil?
    assert_redirected_to @teacher
    follow_redirect!
    assert_template 'teachers/show'
  end

  test "teacher login with invalid infomation" do
    get teachers_login_path
    post teachers_login_path, params: { teacher: { email: @teacher.email, password: '' } }
    assert session[:teacher_id].nil?
    assert_template 'teachers/login_form'
  end

  test "teacher logout with valid" do
    get teachers_login_path
    post teachers_login_path, params: { teacher: { email: @teacher.email, password: 'jiyujyuku' } }
    assert_not session[:teacher_id].nil?
    delete teachers_logout_path
    assert session[:teacher_id].nil?
    assert cookies['teacher_id'].nil?
    assert_redirected_to teachers_login_path
  end

  test "remember_me_box should be check" do
    get teachers_login_path
    post teachers_login_path, params: { teacher: { email: @teacher.email, password: 'jiyujyuku' },
    remember_me: 'no' }
    assert cookies['remember_token'].nil?
    delete teachers_logout_path
    post teachers_login_path, params: { teacher: { email: @teacher.email, password: 'jiyujyuku' },
    remember_me: 'yes' }
    assert_not cookies['remember_token'].nil?
  end

end
