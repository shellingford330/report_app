# frozen_string_literal: true

require 'test_helper'

class StudentSignupTestTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "valid signup information with account activation" do
    get root_path
    assert_difference 'Student.count', 1 do
      post students_path, params: { student: { name: "鈴木　一郎",
                                               email: "ichiro@example.com",
                                               grade: "年少",
                                               passoword: "password",
                                               password: "password", },
                                    first_name: "ichiro", }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    student = assigns(:student)
    assert_not student.activated?
    # 有効化されていない状態でログインする
    student_login_as(student)
    student_is_logged_in?

    get account_activation_url(student.activation_token, login_id: student.login_id)
    assert_equal 2, ActionMailer::Base.deliveries.size
    assert_not student.activated?
  end
end
