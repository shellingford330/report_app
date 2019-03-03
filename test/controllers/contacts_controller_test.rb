require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact = contacts(:one)
  end

  test "should get index" do
    get contacts_url
    assert_redirected_to students_login_url
  end

  test "should get new" do
    get new_contact_url
    assert_redirected_to students_login_url
  end

  test "should create contact" do
    assert_difference('Contact.count', 0) do
      post contacts_url, params: { contact: { content: @contact.content, student_id: @contact.student_id, teacher_id: @contact.teacher_id, title: @contact.title } }
    end

    assert_redirected_to students_login_url
  end

  test "should show contact" do
    get contact_url(@contact)
    assert_redirected_to students_login_url
  end

  test "should get edit" do
    get edit_contact_url(@contact)
    assert_redirected_to students_login_url
  end

  test "should update contact" do
    patch contact_url(@contact), params: { contact: { content: @contact.content, student_id: @contact.student_id, teacher_id: @contact.teacher_id, title: @contact.title } }
    assert_redirected_to students_login_url
  end

  test "should destroy contact" do
    assert_difference('Contact.count', 0) do
      delete contact_url(@contact)
    end

    assert_redirected_to students_login_url
  end
end
