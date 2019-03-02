class CreateJoinTableNewsStudent < ActiveRecord::Migration[5.0]
  def change
    create_join_table :news, :students
  end
end
