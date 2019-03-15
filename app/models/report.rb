class Report < ApplicationRecord
  attr_accessor :subjects

  belongs_to :student
  belongs_to :teacher
  has_many :replies, as: :replyable

  default_scope { order(created_at: :desc) }
  enum status: { draft: 0, released: 1, deleted: 2 }

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status,
    presence: true,
    inclusion: { in: [ "draft", "released", "deleted" ], allow_nil: true }
  validates :teacher_id, presence: true
  validates :student_id, presence: true

end
