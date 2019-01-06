class Student < ApplicationRecord
	has_secure_password
	before_save { self.email.downcase! }

	validates :name,  { presence: true, length: { maximum: 20 } }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, { presence: true, length: { maximum: 255 },
											format: { with: VALID_EMAIL_REGEX },
											uniqueness: { case_sentive: false }
										}
	validates :password, { presence: true, length: { minimum: 6 } }

	def Student.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
	end
end
