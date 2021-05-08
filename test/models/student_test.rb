# frozen_string_literal: true

require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    @student = Student.new(name: "suzuki", grade: "u4", email: "user@example.com",
                           password: "foobar", password_confirmation: "foobar", lesson_day: "月 火",)
  end

  test "name should be present" do
    @student.name = ""
    assert_not @student.valid?
  end

  test "grade should be present" do
    @student.grade = ""
    assert_not @student.valid?
  end

  test "name should not be too long" do
    @student.name = "a" * 51
    assert_not @student.valid?
  end

  test "email validation should reject invalid adresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@exmaple.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |address|
      @student.email = address
      assert_not @student.valid?, "#{address} should be invalid"
    end
  end

  test "password should not be too short" do
    @student.password = @student.password_confirmation = "a" * 5
    assert_not @student.valid?
  end

  test "password should be present" do
    @student.password = @student.password_confirmation = " "
    assert_not @student.valid?
  end

  test "authenticated? should be false with remember_digest nil" do
    assert_not @student.authenticated?(:remember, '')
  end

  test "associated reports should be destroyed" do
    @student.save
    @student.reports.create!(start_date: Date.today, end_date: Date.tomorrow, status: 1, read_flg: false,
      teacher: teachers(:owner),)
    assert_difference 'Report.count', -1 do
      @student.destroy
    end
  end
end
