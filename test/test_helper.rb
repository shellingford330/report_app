ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  # テストユーザーがログイン中の場合にtrueを返す
  def student_is_logged_in?
    !session[:student_id].nil?
  end

end

class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする
  def student_login_as(student, password: 'password', remember_me: '1')
    post root_path, params: { student: { login_id: student.login_id,
                                                   password: password },
                                        remember_me: remember_me }
  end
end