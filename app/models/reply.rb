# frozen_string_literal: true

class Reply < ApplicationRecord
  attr_accessor :exists

  belongs_to :replyable, polymorphic: true
  belongs_to :writeable, polymorphic: true

  default_scope { order(created_at: :asc) }

  scope :read,   -> { where(read_flg: true) }
  scope :unread, -> { where(read_flg: false) }
  scope :written_by, ->(writer) { where(writeable_type: writer) }

  validates :content, presence: true

  # 渡されたリプライの書いた先生を返す
  def teacher
    Teacher.find(writeable_id)
  end

  # 渡されたリプライの書いた生徒を返す
  def student
    Student.find(writeable_id)
  end

  # コメントされたら返信相手に通知メール
  def send_create_reply_mail
    NoticeMailer.create_reply(self).deliver_now
  end
end
