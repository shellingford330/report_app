# frozen_string_literal: true

module User
  include Token

  # トークンを生成し、ハッシュ化した物をDBに保存
  def remember
    self.remember_token = Token.generate
    update_attribute(:remember_digest, Token.digest(remember_token))
  end

  # 講師に保存されているトークンを破棄
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # 有効化トークンおよびダイジェストを作成および代入
  def create_activation_digest
    self.activation_token  = Token.generate
    self.activation_digest = Token.digest(activation_token)
  end

  # パスワード再設定する際に本人かどうか確認のためのトークンとダイジェストを作成
  def create_reset_digest
    self.reset_token = Token.generate
    update_columns(reset_digest:  Token.digest(reset_token),
                        reset_sent_at: Time.zone.now,)
  end
end
