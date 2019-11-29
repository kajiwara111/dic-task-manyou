# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#---------------
# 管理ユーザー
#---------------
User.create(
  name:  'kaji',
  email: 'kaji@gmail.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

User.create(
  name:  'kaji11',
  email: 'kaji11@gmail.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

#---------------
# 一般ユーザー
#---------------
20.times do |n|
  name  = "user#{n}"
  email = Faker::Internet.email
  password = 'password'
  #admin = false デフォルトをfalseで設定しているので、これなくてもfalseが設定される。これを入れてcreateするとnot null制約のエラーになる。
  User.create(
    name:  name,
    email: email,
    password: password,
    password_confirmation: password
  )
end

#---------------
# タスク登録
#---------------

user_id_arr = User.all.pluck(:id)

300.times do |n|
  task_name  = "task#{n}"
  task_content = "タスク内容#{n}"
  deadline = Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 30).strftime("%Y/%m/%d %H:%M")
  created_at = Faker::Time.between(from: DateTime.now - 10, to: DateTime.now)
  state = rand(0..2)
  priority = rand(0..2)
  user_id = user_id_arr.sample
  Task.create(
    task_name:  task_name,
    task_content: task_content,
    deadline: deadline,
    created_at: created_at,
    state: state,
    priority: priority,
    user_id: user_id
  )
end

#---------------
# ラベル登録
#---------------
10.times do |n|
  name = "label_#{n}"
  Label.create(
    name: name
  )
end


#---------------------------------
# ラベルとタスクを紐づける中間テーブル
#---------------------------------

#登録したタスクすべてにランダムな数のラベルを付与
Task.all.each do |task|
  #ラベルのID一覧を取得し、ランダムに並べ替え
  label_id_arr = Label.all.pluck(:id).shuffle  
  #付与するラベルの数をランダム設定
  num_label = rand(1..5)
  num_label.times {
    label_id = label_id_arr.pop #同じラベルをつけないようにpopメソッド使用

    Labelling.create(
      task_id: task.id,
      label_id: label_id
    )
  }
end


