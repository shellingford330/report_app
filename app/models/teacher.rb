class Teacher < ApplicationRecord
	attr_accessor :remember_token, :activation_token
	has_secure_password

	has_many :replies,  as: :writeable
	has_many :contacts, dependent: :destroy
	has_many :news,     dependent: :destroy
	has_many :reports,  dependent: :destroy
	has_many :students, through: :reports
	has_many :sent_messages, class_name: "Message", foreign_key: "from_id", dependent: :destroy
	has_many :recieved_messages, class_name: "Message", foreign_key: "to_id", dependent: :destroy

	before_save { self.email.downcase! }
	before_create :create_activation_digest
	after_destroy { Rails.logger.info("##### Teacher is deleted with #{self.attributes.inspect} ######") }
	
	enum status: { teacher: 0, manager: 1, owner: 2 }
	
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

	# 引数で受け取った文字列をハッシュ化
	def Teacher.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
	end

	# ランダムな文字列を生成
	def Teacher.new_token
		SecureRandom.urlsafe_base64
	end

	# トークンを生成し、ハッシュ化した物をDBに保存
	def remember
		self.remember_token = Teacher.new_token
		update_attribute(:remember_digest, Teacher.digest(remember_token))
	end

	# 講師に保存されているトークンを破棄
	def forget
		update_attribute(:remember_digest, nil)
	end
	
	# 渡されたトークンがダイジェストと一致したらtrueを返す
	def authenticated?(attribute, token)
		digest = self.send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
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


	# 有効化トークンおよびダイジェストを作成および代入
	def create_activation_digest
		self.activation_token  = Teacher.new_token
		self.activation_digest = Teacher.digest(activation_token)
	end
	
end
