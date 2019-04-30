class Contact < ApplicationRecord
  belongs_to :student
  belongs_to :teacher
  has_many :replies, as: :replyable

  default_scope { order(created_at: :desc) }
  
  validates :title, 
    presence: true,
    length: { maximum: 32 }
  validates :content, presence: true

  # お問い合わせ作成時に通知メール
	def send_create_contact_mail
    NoticeMailer.create_contact(self).deliver_now
  end

end
