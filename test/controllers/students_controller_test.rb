require 'test_helper'

class StudentsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect index when not logged in" do
    get students_path
    assert_redirected_to students_login_path
  end
end
