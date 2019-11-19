require 'rails_helper'

RSpec.describe Task, type: :system do
  before do
    #FactoryBot.create(:task, task_name: 'task', task_content: 'rspec test')
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
  end

  describe 'タスク一覧画面' do
    context 'タスクを作成した場合' do
      it '作成済みのタスクが表示されること' do
        #task = FactoryBot.create(:task, task_name: 'task')
        visit tasks_path
        expect(page).to have_content 'task'
      end
    end
  end

  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存されること' do
        visit new_task_path
        fill_in 'タスク名', with: 'specタスク'
        fill_in 'タスク詳細', with: 'specによるテスト演習'
        fill_in '期限', with: '2019/12/10 10:00'
        click_button '登録'
        expect(page).to have_content 'specタスク'
        expect(page).to have_content '2019/12/10 10:00'
      end
    end
  end

  describe 'タスク詳細画面' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示されたページに遷移すること' do
        #FactoryBot.create(:task, task_name: 'task', task_content: 'rspec test')
        visit tasks_path
        #click_on '詳細'
        within('#task_no1') do
          click_on '詳細'
        end
        expect(page).to have_content 'task2'
        expect(page).to have_content 'task_content2'
      end
    end
  end

  describe 'タスク一覧画面における登録日時降順ソート' do
    it 'タスク登録日時の大小関係が正しいこと' do
      visit tasks_path
      tasks = all('.task_list')
      expect(tasks[0]).to have_content 'task2'
    end
  end

  describe '終了期限によるソート機能検証' do
    it '終了期限でソート（昇順）した場合の表示順序が正しいこと' do
      visit tasks_path
      click_on '終了期限でソートする'
      tasks = all('.task_list')
      expect(tasks[0]).to have_content '2019/12/18 18:00'
    end
  end
end