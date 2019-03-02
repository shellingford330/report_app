class AddIndexToNewsStudents < ActiveRecord::Migration[5.0]
  def change
    add_index :news_students, :student_id
  end
end
