class AddIndexToGroupsStudent < ActiveRecord::Migration[5.0]
  def change
    add_index :groups_students, :student_id
  end
end
