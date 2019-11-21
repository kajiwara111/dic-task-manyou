require 'rails_helper'

RSpec.describe Task, type: :system do
  before do
    #FactoryBot.create(:task, task_name: 'task', task_content: 'rspec test')
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
    FactoryBot.create(:third_task)
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
        expect(page).to have_content 'task3'
        expect(page).to have_content 'task_content3'
      end
    end
  end

  describe 'タスク一覧画面における登録日時降順ソート' do
    it 'タスク登録日時の大小関係が正しいこと' do
      visit tasks_path
      tasks = all('.task_list')
      expect(tasks[0]).to have_content 'task3'
    end
  end

  describe 'ソート機能検証' do
    context '終了期限で昇順ソートした場合' do
      it '終了期限でソート（昇順）した場合の表示順序が正しいこと' do
        visit tasks_path
        #find('label[for=期限の近いタスク]').click
        choose 'sort_type_1' #ラベル名「期限の近いタスク」だとElementsNotFoundでエラーになる
        click_on '選択した条件でソートする'
        tasks = all('.task_list')
        expect(tasks[0]).to have_content '2019/12/18 18:00'
      end
    end
    context '優先順位で降順ソートした場合' do
      it '優先順位でソート（降順）した場合の表示順序が正しいこと' do
        visit tasks_path
        #find('label[for=期限の近いタスク]').click
        choose 'sort_type_2' #ラベル名「期限の近いタスク」だとElementsNotFoundでエラーになる
        click_on '選択した条件でソートする'
        tasks = all('.task_list')
        expect(tasks[0]).to have_content 'task2'
      end
    end
  end

  describe '検索機能検証' do
    context 'タスク名で検索した場合' do
      it '検索結果のタスク名が検索に使用した文字列を含んでいること' do
        visit tasks_path
        #下記idはransackによって自動割り当てされている
        fill_in 'q_task_name_cont', with: '3' #ラベル名「期限の近いタスク」だとElementsNotFoundでエラーになる
        click_on '検索'
        tasks = all('.task_list')
        for task in tasks do
          expect(task).to have_content '3'
        end
      end
    end
    context 'ステータスで検索した場合' do
      it '検索結果のステータスが検索対象ステータスのみの表示になっていること' do
        visit tasks_path
        #find('label[for=期限の近いタスク]').click
        select "完了", from: 'q_state_eq' #q_state_eqはransackによって自動割り当てされたid ブラウザ上でHTML確認して気づいた
        click_on '検索'
        tasks = all('.task_list')
        for task in tasks do
          expect(task).to have_content '完了'
        end

      end
    end
    context 'タスク名かつステータスで検索した場合' do
      it '検索結果のタスク名、ステータスが検索対象のもののみの表示になっていること' do
        visit tasks_path
        fill_in 'q_task_name_cont', with: '2' #ラベル名「期限の近いタスク」だとElementsNotFoundでエラーになる
        select "完了", from: 'q_state_eq'
        click_on '検索'
        tasks = all('.task_list')
        for task in tasks do
          expect(task).to have_content '2'
          expect(task).to have_content '完了'
        end
      end
    end
  end
end