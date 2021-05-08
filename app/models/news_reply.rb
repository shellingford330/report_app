# frozen_string_literal: true

class NewsReply < ApplicationRecord
  belongs_to :news
  belongs_to :student
  belongs_to :teacher

  enum sender_type: { student: 0, teacher: 1 }, _prefix: :from

  validates :news,    presence: true
  validates :student, presence: true
  validates :teacher, presence: true
  validates :content, presence: true
  validates :sender_type, presence: true, length: { maximum: 500 }
end
