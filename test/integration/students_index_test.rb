require 'test_helper'

class StudentsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @student = students(:keiichi) 
  end
  test "index including pagination" do
    get students_login_path
    post students_login_path, params: { student:  { email: @student.email,
                                                    password: "keiichi" } ,
                                        remember_me: 'yes' }
    get students_path
    assert_template 'students/index'
    assert_select 'div.pagination'
    Student.paginate(page:1, per_page: 10).each do |student|
      assert_select 'a[href=?]', student_path(student)
    end
  end
end
