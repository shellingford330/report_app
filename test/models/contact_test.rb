# frozen_string_literal: true

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  def setup
    @contact = contacts(:one)
  end

  test "title should be present" do
    @contact.title = ""
    assert @contact.invalid?
  end

  test "content should be present" do
    @contact.content = ""
    assert @contact.invalid?
  end

  test "title should not be too long" do
    @contact.title = "a" * 33
    assert @contact.invalid?
  end

  test "student should be present" do
    @contact.student_id = nil
    assert @contact.invalid?
  end

  test "teacher should be present" do
    @contact.teacher_id = nil
    assert @contact.invalid?
  end
end
