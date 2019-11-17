# テーブル定義

## usersテーブル

|カラム名|データ型|Comment|
|---|---|---|
|id|integer|PK|
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