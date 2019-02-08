class CreateTeachers < ActiveRecord::Migration[5.0]
  def change
    create_table :teachers do |t|
      t.string :name
      t.string :email
      t.integer :status
      t.string :password_digest

      t.timestamps
    end
  end
end
