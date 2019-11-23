# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


50.times do |n|
  task_name  = "task#{n}"
  task_content = "タスク内容#{n}"
  deadline = Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 30).strftime("%Y/%m/%d %H:%M")
  created_at = Faker::Time.between(from: DateTime.now - 10, to: DateTime.now)
  state = rand(0..2)
  priority = rand(0..2)
  Task.create!(task_name:  task_name,
               task_content: task_content,
               deadline: deadline,
               created_at: created_at,
               state: state,
               priority: priority
               )
end

5.times do |n|
  name  = "user#{n}"
  email = Faker::Internet.email
  password = 'password'
  User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password,
               )
end

