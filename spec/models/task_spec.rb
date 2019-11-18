require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'task_nameが存在しかつ30文字以内、およびtask_contentが300文字以内であれば有効なこと' do
    expect(FactoryBot.build(:task)).to be_valid
  end

  it "task_nameが空ならバリデーションが通らない" do
    task = FactoryBot.build(:task, task_name: '', task_content: '失敗テスト')
    expect(task).not_to be_valid
  end

  it 'task_nameが31文字以上ならバリデーションが通らない' do
    test_str = "a" * 31
    task = FactoryBot.build(:task, task_name: test_str, task_content: '失敗テスト')
    expect(task).not_to be_valid
  end 

  it 'task_contentが301文字以上ならバリデーションが通らない' do
    test_str = "a" * 301
    task = FactoryBot.build(:task, task_name: 'test', task_content: test_str)
    expect(task).not_to be_valid
  end
end

