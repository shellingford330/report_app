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
end
