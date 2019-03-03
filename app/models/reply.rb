class Reply < ApplicationRecord
  belongs_to :replyable, polymorphic: true
  belongs_to :writeable, polymorphic: true

  default_scope { order(created_at: :asc) }
  
  validates :content, presence: true
end
