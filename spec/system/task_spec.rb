require 'rails_helper'

RSpec.describe Task, type: :system do
  before do
    FactoryBot.create(:task, task_name: 'task', task_content: 'rspec test')
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
        fill_in 'タスク名称', with: 'specタスク'
        fill_in 'タスク詳細', with: 'specによるテスト演習'
        click_button '登録'
        expect(page).to have_content 'specタスク'
        expect(page).to have_content 'specによるテスト演習'
      end
    end
  end

  describe 'タスク詳細画面' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示されたページに遷移すること' do
        #FactoryBot.create(:task, task_name: 'task', task_content: 'rspec test')
        visit tasks_path
        click_on '詳細'
        expect(page).to have_content 'task'
        expect(page).to have_content 'rspec test'
      end
    end
  end
end