require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get '/login'
    assert_response :success
  end

end
