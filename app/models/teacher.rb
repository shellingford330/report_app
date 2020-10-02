class Teacher < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :reset_token

	mount_uploader :image, ImageUploader
	include User

	has_secure_password

	has_many :replies,  as: :writeable
	has_many :news,     dependent: :destroy
	has_many :reports,  dependent: :destroy
	has_many :students, through: :reports
	has_many :sent_messages, class_name: "Message", foreign_key: "from_id", dependent: :destroy
	has_many :recieved_messages, class_name: "Message", foreign_key: "to_id", dependent: :destroy

	before_save { self.email.downcase! }
	before_create :create_activation_digest
	after_destroy do
		logger.info("Teacher is deleted: #{self.attributes.inspect}")
	end
	
	enum status: { teacher: 0, manager: 1, owner: 2 }

	scope :admin,   -> { owner.or(Teacher.manager) }  
	
	validates :name,
		presence: true,
		length: { maximum: 50, allow_nil: true }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email,
		presence: true,
		length: { maximum: 255, allow_nil: true },
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sentive: false }
	validates :status,
		inclusion:{ in: [ "teacher", "manager" ], if: Proc.new { |teacher| teacher.changed == ["status"] } }
	validates :password,
		presence: true,
		length: { minimum: 6, allow_nil: true },
		allow_nil: true
	validate do |teacher|
		if teacher.image.size > 5.megabytes
			errors.add(:image, "5MB以下にして下さい。")
		end
	end

	def admin?
		owner? || manager?
	end

	def invert_status
		status = { "teacher" => "講師", "manager" => "管理者", "owner" => "オーナー" }
		status[self.status]
	end

	
	# 講師有効化のメール
	def send_create_teacher_mail
    NoticeMailer.create_teacher(self).deliver_now
	end

	# オーナーが講師登録承認のメール
	def send_teacher_activation_mail
    NoticeMailer.activate_teacher(self).deliver_now
	end

	# 講師の作成時に通知メール
	def send_teacher_authentication_mail
    NoticeMailer.authenticate_teacher(self).deliver_now
	end

	# パスワード再設定用のメール
	def send_password_reset_email
		NoticeMailer.password_reset(self).deliver_now
	end
	
end
