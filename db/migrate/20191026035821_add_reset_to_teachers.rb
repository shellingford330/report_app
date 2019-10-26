class AddResetToTeachers < ActiveRecord::Migration[5.0]
  def change
    add_column :teachers, :reset_digest, :string
    add_column :teachers, :reset_sent_at, :datetime
  end
end
