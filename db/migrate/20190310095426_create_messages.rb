class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :from_id
      t.integer :to_id

      t.timestamps
    end
    add_index :messages, [:from_id, :to_id]
    add_index :messages, [:to_id, :from_id]
  end
end
