FROM ruby:2.7.5

# 必要なパッケージ(nodejs)をインストール
RUN apt-get update -qq && apt-get install -y nodejs

ENV APP_ROOT /app

WORKDIR ${APP_ROOT}

COPY Gemfile ${APP_ROOT}
# COPY Gemfile.lock ${APP_ROOT}

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server"]

