class Student < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :reset_token, :lesson_days

	mount_uploader :image, ImageUploader

	has_secure_password

	has_and_belongs_to_many :news
	has_and_belongs_to_many :groups
	has_many :replies,  as: :writeable
	has_many :contacts, dependent: :destroy
	has_many :reports,  dependent: :destroy
	has_many :teachers, through: :reports

	before_create :create_activation_digest
	after_destroy do
		Rails.logger.info("##### Student is deleted with #{self.attributes.inspect} ######") 
	end
	after_find do
		self.lesson_days = lesson_day.try(:split)
	end

	VALID_LOGIN_ID_REGEX = /\A.+_.+\Z/
	validates :login_id, { uniqueness: true, 
												 format: { with: VALID_LOGIN_ID_REGEX } }
	validates :grade,    { presence: true }
	validates :name,     { presence: true, length: { maximum: 50 } }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email,    { presence: true, 
												 length: { maximum: 255 },
												 format: { with: VALID_EMAIL_REGEX } }
	validates :password, { presence: true, length: { minimum: 6 }, allow_nil: true }
	validate do |student|
		if student.image.size > 5.megabytes
			errors.add(:image, "5MB以下にして下さい。")
		end
	end

	# 引数で受け取った文字列をハッシュ化
	def Student.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
	end

	# ランダムな文字列を返す
	def Student.new_token
		SecureRandom.urlsafe_base64
	end

	# トークンを生成し、ハッシュ化したものをデータベースに保存
	def remember
		self.remember_token = Student.new_token
		update_attribute(:remember_digest, Student.digest(remember_token) )
	end

	# 記憶トークンを破棄
	def forget
		update_attribute(:remember_digest, nil)
	end

	# 渡されたトークンがダイジェストと一致したらtrueを返す
	def authenticated?(attribute, token)	
		digest = self.send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
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
	
	# 有効化トークンおよびダイジェストを作成および代入
	def create_activation_digest
		self.activation_token  = Student.new_token
		self.activation_digest = Student.digest(activation_token)
	end

	# パスワード再設定する際に本人かどうか確認のためのトークンとダイジェストを作成
	def create_reset_digest
		self.reset_token = Student.new_token
		self.update_columns(reset_digest:  Student.digest(self.reset_token),
												reset_sent_at: Time.zone.now)
	end

	
end
