require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    @student = Student.new(name: "suzuki", email: "user@example.com",
                           password: "foobar", password_confirmation: "foobar")
  end

  test "name should be present" do
    @student.name = ""
    assert_not @student.valid?
  end

  test "name should not be too long" do
    @student.name = "a" * 21
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

  test "email should be unique" do
    duplicate_student = @student.dup
    @student.save
    assert_not duplicate_student.valid?
  end
  
  test "email should change into downcase before save" do
    address = "FOObar@exaPle.Com"
    @student.email = address
    @student.save
    assert_equal address.downcase, @student.reload.email
  end

  test "password should not be too short" do
    @student.password = @student.password_confirmation = "a" * 5
    assert_not @student.valid?
  end

  test "password should be present" do
    @student.password = @student.password_confirmation = " "
    assert_not @student.valid?
  end
end
