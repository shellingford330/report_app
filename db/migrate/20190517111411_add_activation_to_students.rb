class AddActivationToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :activation_digest, :string
    add_column :students, :activated, :boolean, default: false
    add_column :students, :activated_at, :datetime
  end
end
