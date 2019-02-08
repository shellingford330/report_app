json.extract! teacher, :id, :name, :email, :status, :password_digest, :created_at, :updated_at
json.url teacher_url(teacher, format: :json)
