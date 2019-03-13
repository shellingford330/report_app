class Teacher < ApplicationRecord
	attr_accessor :remember_token
	has_secure_password

	has_many :replies,  as: :writeable
	has_many :contacts, dependent: :destroy
	has_many :news,     dependent: :destroy
	has_many :reports,  dependent: :destroy
	has_many :students, through: :reports
	has_many :sent_messages, class_name: "Message", foreign_key: "from_id", dependent: :destroy
	has_many :recieved_messages, class_name: "Message", foreign_key: "to_id", dependent: :destroy

	before_save { self.email.downcase! }
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
	def authenticated?(remember_token)
		return false if self.remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end
end
