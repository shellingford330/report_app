class CreateReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :replies do |t|
      t.text :content, null: false
      t.references :replyable, polymorphic: true
      t.references :writeable, polymorphic: true

      t.timestamps
    end
  end
end
