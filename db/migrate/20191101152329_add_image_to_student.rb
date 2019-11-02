class AddImageToStudent < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :image, :string
  end
end
