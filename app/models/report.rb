class Report < ApplicationRecord
  attr_accessor :subjects

  belongs_to :student
  belongs_to :teacher
  has_many :replies, as: :replyable

  default_scope { order(created_at: :desc) }

  enum status: { draft: 0, released: 1, deleted: 2 }

  after_initialize :set_params

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status,
    presence: true,
    inclusion: { in: [ "draft", "released", "deleted" ], allow_nil: true }
  validates :teacher_id, presence: true
  validates :student_id, presence: true

  # 指導報告書の教科
  def Report.subjects
    ['算数', '数学', '国語', '英語', '理科', '社会', 'その他', '都立中対策', '思考・表現', 'ロボットプログラミング教室']
  end

  # 教科を配列化
  def array_subject
    self.subjects = self.subject.split
  end

  # 指導報告書作成時に通知メール
  def send_create_report_mail
    NoticeMailer.create_report(self).deliver_now
  end

  private
    # 指導報告書にデフォルトパラメーターをセット
    def set_params
      self.end_date   = 15.days.ago
      self.start_date = 1.day.ago
			self.homework   = "学習記録をご覧下さい。"
    end

end
