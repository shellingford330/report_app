class AddReadFlgToContactsAndReplies < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :read_flg, :boolean, default: false, null: false
    add_column :replies, :read_flg, :boolean, default: false, null: false
  end
end
