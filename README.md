# What's this?

これは自由塾の指導報告書サービスです。

# How to use

### 1. アプリケーションをcloneする

```
$ git clone git@github.com:shellingford330/report_app.git
```

### 2. セットアップ

```
$ docker-compose run web rails db:setup
$ docker-compose up --build
```

### 3. アクセス

ブラウザから http://localhost:3000 でアクセスできます。

