json.extract! news, :id, :title, :content, :status, :teacher, :created_at, :updated_at
json.url news_url(news, format: :json)
