class Teacher < ApplicationRecord
	has_secure_password
	before_save { self.email.downcase! }
	enum status: { teacher: 0, manager: 1, owner: 2 }
	
	validates :name,
		presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email,
		presence: true,
		length: { maximum: 255 },
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sentive: false }
	validates :status,
		presence: true,
		inclusion:{ in: [ "teacher", "manager" ] , allow_nil: true }
	validates :password,
		presence: true,
		length: { minimum: 6, allow_nil: true },
		allow_nil: true
end
