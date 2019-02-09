class AddDefaultToTeachersStatus < ActiveRecord::Migration[5.0]
  def change
    change_column_default :teachers, :status, 0
  end
end
