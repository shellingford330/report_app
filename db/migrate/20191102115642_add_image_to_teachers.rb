class AddImageToTeachers < ActiveRecord::Migration[5.0]
  def change
    add_column :teachers, :image, :string
  end
end
