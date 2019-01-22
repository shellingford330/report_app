class RemoveUniqueToStudentsGrade < ActiveRecord::Migration[5.0]
  def change
    remove_index :students, :grade
    add_index :students, :grade
  end
end
