json.extract! contact, :id, :title, :content, :student_id, :teacher_id, :created_at, :updated_at
json.url contact_url(contact, format: :json)
