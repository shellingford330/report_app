class Report < ApplicationRecord
  belongs_to :student
  belongs_to :teacher

  default_scope { order(created_at: :desc) }
  enum status: { draft: 0, released: 1, deleted: 2 }

  validates :start_date, presence: true
  validates :start_date, presence: true
  validates :student_id, presence: true
  validates :teacher_id, presence: true

end
