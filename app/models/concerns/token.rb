module Token
	# ランダムな文字列を返す
	def generate
		SecureRandom.urlsafe_base64
	end

	# 引数で受け取った文字列をハッシュ化
	def digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
																									BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	module_function :generate, :digest
end