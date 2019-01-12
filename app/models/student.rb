class Student < ApplicationRecord
	attr_accessor :remember_token
	has_secure_password
	before_save { self.email.downcase! }

	validates :name,  { presence: true, length: { maximum: 20 } }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, { presence: true, length: { maximum: 255 },
											format: { with: VALID_EMAIL_REGEX },
											uniqueness: { case_sentive: false }
										}
	validates :password, { presence: true, length: { minimum: 6 } }

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
	def authenticated?(remember_token)
		return false if self.remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end
end
