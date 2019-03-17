class AddLessonsDayToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :lesson_day, :string
  end
end
