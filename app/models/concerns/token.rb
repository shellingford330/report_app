# frozen_string_literal: true

module Token
  # ランダムな文字列を返す
  def generate
    SecureRandom.urlsafe_base64
  end

  # 引数で受け取った文字列をハッシュ化
  def digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  module_function :generate, :digest
end
