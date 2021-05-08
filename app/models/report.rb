# frozen_string_literal: true

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
            inclusion: { in: %w[draft released deleted], allow_nil: true }
  validates :teacher_id, presence: true
  validates :student_id, presence: true

  # 指導報告書の教科
  def self.subjects
    ['算数', '数学', '国語', '英語', '理科', '社会', 'その他', '都立中対策', '思考・表現', 'ロボットプログラミング教室']
  end

  # 教科を配列化
  def array_subject
    self.subjects = subject.split
  end

  # 指導報告書作成時に通知メール
  def send_create_report_mail
    NoticeMailer.create_report(self).deliver_now
  end
end
