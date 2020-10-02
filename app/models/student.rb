class Student < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :reset_token, :lesson_days, :first_name, :last_name

	mount_uploader :image, ImageUploader
	include User

	has_secure_password

	has_and_belongs_to_many :news
	has_and_belongs_to_many :groups
	has_many :replies,  as: :writeable
	has_many :contacts
	has_many :reports
	has_many :teachers, through: :reports

	before_create :create_activation_digest
	after_destroy do
		logger.info("Student is deleted: #{self.attributes.inspect}") 
	end
	after_find do
		self.lesson_days = lesson_day.try(:split)
	end

	VALID_LOGIN_ID_REGEX = /\A.+_.+\Z/
	validates :login_id,   { uniqueness: true, 
												   format: { with: VALID_LOGIN_ID_REGEX } }
	validates :first_name, { presence: true, on: :create }
	validates :grade,      { presence: true }
	validates :name,       { presence: true, length: { maximum: 50 } }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email,      { presence: true, 
												   length: { maximum: 255 },
												   format: { with: VALID_EMAIL_REGEX, allow_blank: true } }
	validates :password,   { presence: true, length: { minimum: 6 }, allow_nil: true }
	validate do |student|
		if student.image.size > 5.megabytes
			errors.add(:image, "5MB以下にして下さい。")
		end
	end

	# 全部の学年を配列で返す
	def Student.grades
		[ "年少", "年中", "年長", "小学１年生", "小学２年生", "小学３年生", "小学４年生", "小学５年生", "小学６年生",
			"中学１年生", "中学２年生", "中学３年生", "高校１年生", "高校２年生", "高校３年生", "大学１年生", "大学２年生", 
			"大学３年生", "大学４年生", ]
	end

	# 曜日を配列で返す
	def Student.days
		["月", "火", "水", "木", "金", "土", "日"]
	end

	# アカウント有効化のメール
	def send_account_activation_mail
    NoticeMailer.activate_account(self).deliver_now
	end

	# オーナーが生徒登録承認のメール
	def send_authenticate_student_mail
    NoticeMailer.authenticate_student(self).deliver_now
	end

	# 登録された生徒に通知メール
	def send_create_student_mail
    NoticeMailer.create_student(self).deliver_now
	end

	# パスワード再設定用のメール
	def send_password_reset_email
		NoticeMailer.password_reset(self).deliver_now
	end
	
end
