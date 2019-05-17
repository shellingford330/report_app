class AddLoginIdToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :login_id, :string
    add_index  :students, :login_id, unique: true
    remove_index :students, :email
  end
end
