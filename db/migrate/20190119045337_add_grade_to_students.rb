class AddGradeToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :grade, :string
    add_index :students, :grade, unique: true
  end
end
