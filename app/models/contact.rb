class Contact < ApplicationRecord
  attr_accessor :upfile
  include FileValidation
  
  belongs_to :student
  has_many :replies, as: :replyable

  default_scope { order(updated_at: :desc) }
  
  validates :title, 
    presence: true,
    length: { maximum: 32 }
  validates :content, presence: true

  ###############################
  ########### 未読確認 ###########
  ###############################

  # 生徒側が講師からの返信を確認していればtrue, していなければfalseを返す
  def checked_by_student?
    self.replies.written_by("Teacher").unread.exists?
  end

  # 講師側が生徒からのお問い合わせや返信を確認していればtrue, していなければfalseを返す
  def	checked_by_teacher?
    !self.read_flg || self.replies.written_by("Student").unread.exists?
  end

	
	##################################
  ########### 返信有無確認 ###########
  ##################################

	# 講師から返信があるか確認
	def	has_replies?
		self.replies.written_by("Teacher").exists?
  end

end
