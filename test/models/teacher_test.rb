require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  setup do
    @teacher = Teacher.new( name: "keiichi", email: "keiichi@example.com", status: :teacher, 
      password: "keiichi", password_confirmation: "keiichi" )
  end

  test "name should be present" do
    @teacher.name = ""
    assert @teacher.invalid?
  end

  test "email should be present" do
    @teacher.email = ""
     assert @teacher.invalid?
  end

  test "email should not be too long" do
    @teacher.email = "a" * 256
     assert @teacher.invalid?
  end

  test "email should be fixed format" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@exmaple.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |address|
      @teacher.email = address
      assert @teacher.invalid?, "#{address} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_teacher = @teacher.dup
    @teacher.save
    assert_not duplicate_teacher.valid?
  end
  
  test "email should change into downcase before save" do
    address = "FOObar@examPle.Com"
    @teacher.email = address
    @teacher.save
    assert_equal address.downcase, @teacher.reload.email
  end

  test "password should be present" do
    @teacher.password = @teacher.password_confirmation = " " * 6
    assert_not @teacher.valid?
  end

  test "password should have at least 6 length" do
    @teacher.password = @teacher.password_confirmation = "a" * 5
    assert_not @teacher.valid?
  end

  test "status should include in teacher and manager" do
    @teacher.status = :owner
    assert @teacher.invalid?
  end

end
