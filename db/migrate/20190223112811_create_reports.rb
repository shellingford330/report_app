class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :subject
      t.text :content
      t.text :homework
      t.text :comment
      t.integer :status, default: 0, null: false
      t.boolean :read_flg, default: false, null: false
      t.text :memo
      t.references :student, foreign_key: true
      t.references :teacher, foreign_key: true

      t.timestamps
    end
    add_index :reports, [:student_id, :created_at]
    add_index :reports, [:teacher_id, :created_at]
    remove_index :reports, :student_id
    remove_index :reports, :teacher_id
  end
end
