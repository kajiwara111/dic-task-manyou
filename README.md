# テーブル定義

## usersテーブル

|カラム名|データ型|Comment|
|---|---|---|
|id|integer|PK, NotNull|
|name|string|ユーザー名、NotNull|
|email|string|ユーザーメールアドレス。NotNull|
|password_digest|text|ハッシュ化されたパスワード情報、NotNull|

## tasksテーブル

|カラム名|データ型|Comment|
|---|---|---|
|id|integer|PK, NotNull|
|user_id|integer|FK, NotNull|
|task_name|string|タスク名, NotNull|
|task_content|text|タスク詳細, NotNull|


## labelsテーブル

|カラム名|データ型|Comment|
|---|---|---|
|id|integer|PK, NotNull|
|task_id|integer|FK, NotNull|
|label|string|タスクラベル, NotNull|

---

# herokuデプロイ手順

1. `heroku login`でHerokuにログインする

2. デプロイしたいアプリケーションのルートディレクトリで`heroku create [app名]`を実行

3. `git remote -v`でリモートリポジトリにherokuが登録されていること確認

4. `rails assets:precompile RAILS_ENV=production` でアセットプリコンパイル

5. `git add -A`, `git commit`, `git push heroku master`でherokuにデプロイ

6. `heroku run rails db:migrate`でherokuサーバー上でマイグレーション実行

7. herokuとGitHubを連携し、masterが更新されたらherokuに自動デプロイされるよう設定
    - dashboard→アプリ名選択→Deployで、Deployment methodでGitHubを選択し、App connected to GitHubで該当するGitHub上のリポジトリを紐づける
    
    - Automatic deploysを有効にする

