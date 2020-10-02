class CreateNewsReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :news_replies do |t|
      t.string :content, null: false, limit: 500
      t.boolean :is_read, null: false, default: false
      t.integer :sender_type, null: false, limit: 5
      t.references :student, foreign_key: true, null: false
      t.references :teacher, foreign_key: true, null: false
      t.references :news,    foreign_key: true, null: false

      t.timestamps
    end
  end
end
