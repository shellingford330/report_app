class AddUpfileToNews < ActiveRecord::Migration[5.0]
  def change
    add_column :news, :upfile, :string
  end
end
