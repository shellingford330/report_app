require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  setup do
    @teacher = teachers(:owner)
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
    address = "FOObar@exaPle.Com"
    @teacher.email = address
    @teacher.save
    assert_equal address.downcase, @teacher.reload.email
  end

end
