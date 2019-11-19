FactoryBot.define do
  factory :task do
    task_name { 'task1' }
    task_content { 'task_content1' }
    created_at { Time.now }
    deadline {'2019/12/18 18:00'}
  end

  # 作成するテストデータの名前を「second_task」とします
  # （存在しないクラス名の名前をつける場合、オプションで「このクラスのテストデータにしてください」と指定します）
  factory :second_task, class: Task do
    task_name { 'task2' }
    task_content { 'task_content2' }
    created_at { Time.now + 1.days }
    deadline {'2019/12/20 10:00'}
  end 
end
