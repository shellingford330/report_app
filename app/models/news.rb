# frozen_string_literal: true

class News < ApplicationRecord
  # attr_accessor :upfile
  mount_uploader :upfile, UpfileUploader
  include FileValidation

  has_and_belongs_to_many :students
  belongs_to :teacher
  has_many :replies, class_name: "NewsReply"

  default_scope { order(created_at: :desc) }

  enum status: { draft: 0, released: 1, deleted: 2 }

  validates :title,
            presence: true,
             length: { maximum: 32 }
  validates :content, presence: true
  validates :status,
            presence: true,
             inclusion: { in: %w[draft released deleted], allow_nil: true }
  validates :teacher_id, presence: true
  validate :file_invalid?
end
