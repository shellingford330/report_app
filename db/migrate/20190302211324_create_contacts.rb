class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :title
      t.text :content, null: false
      t.references :student, foreign_key: true
      t.references :teacher, foreign_key: true

      t.timestamps
    end
    add_index :contacts, [:student_id, :created_at]
    add_index :contacts, [:teacher_id, :created_at]
    remove_index :contacts, :student_id
    remove_index :contacts, :teacher_id
  end
end
