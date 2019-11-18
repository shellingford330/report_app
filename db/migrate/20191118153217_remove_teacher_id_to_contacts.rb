class RemoveTeacherIdToContacts < ActiveRecord::Migration[5.0]
  def change
    remove_column :contacts, :teacher_id, :integer
  end
end
