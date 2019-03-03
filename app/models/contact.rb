class Contact < ApplicationRecord
  belongs_to :student
  belongs_to :teacher

  default_scope { order(created_at: :desc) }
  
  validates :title, 
    presence: true,
    length: { maximum: 32 }
  validates :content, presence: true
end
