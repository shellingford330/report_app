class CreateJoinTableGroupStudent < ActiveRecord::Migration[5.0]
  def change
    create_join_table :groups, :students
  end
end
