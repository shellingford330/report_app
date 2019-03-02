class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :status, default: 0, null: false
      t.references :teacher, foreign_key: true

      t.timestamps
    end
    add_index :news, [:teacher_id, :created_at]
    remove_index :news, :teacher_id
  end
end
