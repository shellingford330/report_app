class Reply < ApplicationRecord
  attr_accessor :exists

  belongs_to :replyable, polymorphic: true
  belongs_to :writeable, polymorphic: true

  default_scope { order(created_at: :asc) }
  
  validates :content, presence: true

  # コメントされたら返信相手に通知メール
  def send_create_reply_mail
    NoticeMailer.create_reply(self).deliver_now
  end
end
