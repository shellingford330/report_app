class Teacher < ApplicationRecord
	has_secure_password
	before_save { self.email.downcase! }

	validates :name,
		presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email,
		presence: true,
		length: { maximum: 255, allow_nil: true },
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sentive: false }
	validates :status,
	 presence: true
	validates :password,
		presence: true,
		length: { minimum: 6, allow_nil: true },
		allow_nil: true
end
