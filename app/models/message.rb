# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :from, class_name: "Teacher"
  belongs_to :to, class_name: "Teacher"

  default_scope { order(created_at: :asc) }

  validates :from_id, presence: true
  validates :to_id, presence: true
  validates :content, presence: true
end
