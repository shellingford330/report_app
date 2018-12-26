require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_new_url
    assert_response :success
  end

end
