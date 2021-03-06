FactoryBot.define do
  factory :task do
    task_name { 'task1' }
    task_content { 'task_content1' }
    created_at { Time.now + 1.days }
    deadline {'2019/12/18 18:00'}
    state { 1 }
    priority { 1 }
    association :user, factory: :user
    #after(:create) do |task|
    #  create_list(:label, 1, tasks: [task])
    #end

    #has_many through部分のアソシエーション
    after(:build) do |task|
      label = create(:label)
      task.labellings << build(:labelling, task: task, label: label)
    end
    #after(:build) do |task|
    #  task.labellings = FactoryBot.create(:label)
    #end
  end

  # 作成するテストデータの名前を「second_task」とします
  # （存在しないクラス名の名前をつける場合、オプションで「このクラスのテストデータにしてください」と指定します）
  factory :second_task, class: Task do
    task_name { 'task2' }
    task_content { 'task_content2' }
    created_at { Time.now + 2.days }
    deadline {'2019/12/20 10:00'}
    state { 2 }
    priority { 2 }
    association :user, factory: :user2
    after(:build) do |task|
      label = create(:label2)
      task.labellings << build(:labelling, task: task, label: label)
    end
  end 

  factory :third_task, class: Task do
    task_name { 'task3' }
    task_content { 'task_content3' }
    created_at { Time.now + 5.days }
    deadline {'2020/01/03 10:00'}
    state { 0 }
    priority { 0 }
    association :user, factory: :user3
    after(:build) do |task|
      label = create(:label3)
      task.labellings << build(:labelling, task: task, label: label)
    end
  end 

  factory :fourth_task, class: Task do
    task_name { 'task4' }
    task_content { 'task_content4' }
    created_at { Time.now + 10.days }
    deadline {'2020/01/05 10:00'}
    state { 0 }
    priority { 0 }
    association :user, factory: :user4
    after(:build) do |task|
      label = create(:label4)
      task.labellings << build(:labelling, task: task, label: label)
    end
  end 
end


