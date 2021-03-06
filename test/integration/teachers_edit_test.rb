# frozen_string_literal: true

require 'test_helper'

class TeachersEditTest < ActionDispatch::IntegrationTest
  def setup
    @teacher = teachers(:owner)
    @other_teacher = teachers(:manager)
  end

  test "only correct teacher edit and update" do
    get login_form_teachers_path
    post login_teachers_path, params: { teacher: { email: @teacher.email, password: 'jiyujyuku' },
    remember_me: 'no', }
    get edit_teacher_path(@other_teacher)
    assert_redirected_to @teacher
  end
end
