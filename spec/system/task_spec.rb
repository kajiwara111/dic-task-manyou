require 'rails_helper'

RSpec.describe Task, type: :system do
  let!(:user3) { FactoryBot.create(:user3) }
  
  #タスク一覧画面で登録日時で降順(task4が先頭)になるため、task4から記載しておく
  let!(:task4) { FactoryBot.create(:fourth_task, user: user3) }
  let!(:task3) { FactoryBot.create(:third_task, user: user3) }
  let!(:task2) { FactoryBot.create(:second_task, user: user3) }
  let!(:task1) { FactoryBot.create(:task, user: user3) }

  before do
    visit new_session_path
    fill_in 'メールアドレス', with: user3.email
    fill_in 'パスワード', with: user3.password
    click_on 'Log in'
  end

  describe 'タスク一覧画面' do
    it '作成済みのタスクが表示されている' do
      visit tasks_path
      expect(page).to have_content 'task1'
      expect(page).to have_content 'task2'
      expect(page).to have_content 'task3'
      expect(page).to have_content 'task4'
    end
  end

  describe '新規タスク登録機能' do
    context '新規タスク登録した場合の一覧画面' do
      it 'タスク一覧画面に新規登録したタスクについてタスク名、タスク詳細、期限が正しく表示されていること' do
        visit new_task_path
        fill_in 'タスク名', with: 'specタスク'
        fill_in 'タスク詳細', with: 'specによるテスト演習'
        fill_in '期限', with: '2019/12/10 10:00'
        check 'test_label1'
        check 'test_label3'
        click_button '登録'
        expect(page).to have_content 'タスク一覧'
        expect(page).to have_content 'specタスク'
        expect(page).to have_content '2019/12/10 10:00'
      end
    end

    context '新規タスク登録した場合のタスク詳細画面' do
      it 'タスク一覧画面に新規登録した情報がすべて表示されていること' do
        visit new_task_path
        fill_in 'タスク名', with: 'specタスク'
        fill_in 'タスク詳細', with: 'specによるテスト演習'
        fill_in '期限', with: '2019/12/10 10:00'
        check 'test_label1'
        check 'test_label2'
        click_button '登録'
        within('#task_no5') do #FactoryBotで事前作成しているタスクはすべて未来の作成日時。降順ソートされるので、新規作成タスクは5番目
          click_on '詳細'
        end        
        expect(page).to have_content 'specタスク'
        expect(page).to have_content 'specによるテスト演習'
        expect(page).to have_content '2019/12/10 10:00'
        expect(page).to have_content 'test_label1'
        expect(page).to have_content 'test_label2'
      end    
    end
  end

  describe 'タスク詳細画面' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示されたページに遷移すること' do
        visit tasks_path
        within('#task_no1') do
          click_on '詳細'
        end
        expect(page).to have_content 'タスク詳細'
        expect(page).to have_content 'task4'
        expect(page).to have_content 'task_content4'
        expect(page).to have_content 'test_label4'
      end
    end
  end

  describe 'タスク編集機能' do
    context 'タスクを編集して一覧画面を表示した場合' do
      it 'タスク一覧画面に編集内容が反映されていること' do
        visit tasks_path
        within('#task_no1') do
          click_on '詳細'
        end
        click_on '編集'
        fill_in 'タスク名', with: 'task4_edit'
        fill_in 'タスク詳細', with: 'task_content4_edit'
        fill_in '期限', with: '2019/12/30 06:00'
        select '完了', from: 'task_state' #ブラウザの検証画面からselectタグに指定されているidを調べて指定した
        select '中', from: 'task_priority'
        check 'test_label3'
        click_on '更新'
        
        expect(page).to have_content 'タスク一覧'
        expect(page).to have_content 'task4_edit'
        expect(page).to have_content '2019/12/30 06:00'
        expect(page).to have_content '完了'
        expect(page).to have_content '中'
      end
    end

    context 'タスクを編集して編集したタスクの詳細画面を表示した場合' do
      it 'タスク詳細画面に編集内容が反映されていること' do
        visit tasks_path
        within('#task_no1') do
          click_on '詳細'
        end
        click_on '編集'
        fill_in 'タスク名', with: 'task4_edit'
        fill_in 'タスク詳細', with: 'task_content4_edit'
        fill_in '期限', with: '2019/12/30 06:00'
        select '完了', from: 'task_state' #ブラウザの検証画面からselectタグに指定されているidを調べて指定した
        select '中', from: 'task_priority'
        check 'test_label3'
        click_on '更新'
        
        within('#task_no1') do
          click_on '詳細'
        end
        expect(page).to have_content 'タスク詳細'
        expect(page).to have_content 'task4_edit'
        expect(page).to have_content '2019/12/30 06:00'
        expect(page).to have_content '完了'
        expect(page).to have_content '中'
        expect(page).to have_content 'test_label3'
        expect(page).to have_content 'test_label4'
      end
    end    
  end

  describe 'タスク削除機能' do
    context 'タスク削除ボタンを押した場合' do
      it 'タスクが削除されること' do
        within('#task_no1') do
          click_on '削除'
        end      
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "タスクを削除しました"

        #active recordで検索結果、レコード存在しない場合は空の配列が戻り値になる
        expect(Task.where(task_name: 'task4').empty?).to be true
      end
    end
  end

  describe 'タスク一覧画面における登録日時降順ソート' do
    it 'タスク登録日時の大小関係が正しいこと' do
      visit tasks_path
      tasks = all('.task_list')
      expect(tasks[0]).to have_content 'task4'
      expect(tasks[1]).to have_content 'task3'
      expect(tasks[2]).to have_content 'task2'
      expect(tasks[3]).to have_content 'task1'
    end
  end

  describe 'ソート機能' do
    context '終了期限で昇順ソートした場合' do
      it '終了期限でソート（昇順）した場合の表示順序が正しいこと' do
        visit tasks_path
        #find('label[for=期限の近いタスク]').click
        choose 'sort_type_1' #ラベル名「期限の近いタスク」だとElementsNotFoundでエラーになる
        click_on '選択した条件でソートする'
        tasks = all('.task_list')
        expect(tasks[0]).to have_content 'task1'
        expect(tasks[1]).to have_content 'task2'
        expect(tasks[2]).to have_content 'task3'
        expect(tasks[3]).to have_content 'task4'
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
        expect(tasks[1]).to have_content 'task1'
        expect(tasks[2]).to have_content 'task4' #優先度同じ場合は登録日時で降順
        expect(tasks[3]).to have_content 'task3'
      end
    end
  end

  describe '検索機能' do
    context 'タスク名で検索した場合' do
      it '検索結果のタスク名が検索に使用した文字列を含んでいること' do
        visit tasks_path
        #下記idはransackによって自動割り当てされている
        fill_in 'q_task_name_cont', with: '3' #ラベル名「期限の近いタスク」だとElementsNotFoundでエラーになる
        click_on '検索'
        tasks = all('.task_list')
        for task in tasks do #検索結果すべてのタスク名が3を含んでいればOK
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

    context 'ラベル名で検索した場合' do
      it '検索結果に表示されたタスクのラベル名が検索したラベル名を含んでいること' do
        visit tasks_path
        #find('label[for=期限の近いタスク]').click
        select "test_label2", from: 'q_labels_name_eq' #q_state_eqはransackによって自動割り当てされたid ブラウザ上でHTML確認して気づいた
        click_on '検索'
        num_tasks = all('.task_list').length #検索結果のタスク数取得
        
        #検索結果のすべてのタスクの詳細画面を確認し、検索に使用したラベル名が含まれているか確認
        num_tasks.times {|n|
          within("#task_no#{n + 1}") do
            click_on '詳細'
          end
          expect(page).to have_content 'test_label2'
        }
      end
    end

    context 'タスク名、ステータス、ラベル名でAND検索した場合' do
      it '検索結果のタスク名、ステータス、ラベル名が検索対象のもののみの表示になっていること' do
        visit tasks_path
        fill_in 'q_task_name_cont', with: '2' #ラベル名「期限の近いタスク」だとElementsNotFoundでエラーになる
        select "完了", from: 'q_state_eq'
        click_on '検索'

        num_tasks = all('.task_list').length #検索結果のタスク数取得
        
        #検索結果のすべてのタスクの詳細画面を確認し、期待する検索結果と一致すること確認
        num_tasks.times {|n|
          within("#task_no#{n + 1}") do
            click_on '詳細'
          end
          expect(page).to have_content '2'
          expect(page).to have_content '完了'
          expect(page).to have_content 'test_label2'
        }
      end
    end
  end
end