source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.7'

gem 'puma', '3.9.1'
gem 'rails', '5.2.5'
gem 'rails-i18n', '~> 5.1'
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'bootstrap', '~> 4.2.1'
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# ページネーション系
gem 'kaminari'
gem 'will_paginate'

# 画像アップロード系
gem 'carrierwave'
gem 'mini_magick', '4.9.5'

# 非同期実行
# gem 'delayed_job_active_record'

gem 'bootsnap', require: false

gem 'pg'

group :development, :test do
  # 高機能コンソール
  gem 'pry-rails'
  # ステップ実行
  gem 'pry-byebug'
  # gem 'byebug', platform: :mri
  # エラー画面を高機能
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'fog-aws'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
