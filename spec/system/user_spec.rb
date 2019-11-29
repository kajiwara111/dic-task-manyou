require 'rails_helper'

RSpec.describe User, type: :system do
  #事前にuser1~user4を作成しておく
  let!(:user1) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:user3) { FactoryBot.create(:user3) }
  let!(:user4) { FactoryBot.create(:user4) }

  describe 'ログインしてない場合のアクセスコントロール機能' do
    context 'ログインせずにタスク一覧ページにアクセスする場合' do
      it 'ログインページにリダイレクトすること' do
        visit tasks_path
        expect(page).to have_content 'ログインしてください'
        expect(page).to have_content 'Log in'
      end
    end

    context 'ログインせずに新規タスク登録ページにアクセスする場合' do
      it 'ログインページにリダイレクトすること' do
        visit new_task_path
        expect(page).to have_content 'ログインしてください'
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe 'ログイン・ログアウト機能' do
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'user1@gmail.com'
      fill_in 'パスワード', with: 'password'
      click_on 'Log in'
    end
 
    context 'ログインした場合' do
      it 'タスク一覧ページが表示されること' do
        expect(page).to have_content 'タスク一覧'
      end
    end
 
    context 'ログアウトした場合' do
      it 'ログインページに遷移すること' do
        click_on 'Logout'
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe 'ユーザー管理機能' do    
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: login_user.email #login_userはしたの階層で定義されている。
      fill_in 'パスワード', with: login_user.password
      click_on 'Log in'
    end
    
    describe 'ユーザー一覧機能' do
      context '管理者としてログインした場合' do
        let(:login_user) { user1 }
        it 'ユーザー管理画面に遷移できること' do
          expect(page).to have_content 'ユーザー管理画面'
          click_on 'ユーザー管理画面'
          expect(page).to have_content 'ユーザー一覧'
        end
      end

      context '一般ユーザーとしてログインした場合' do
        let(:login_user) { user3 }
        it 'ユーザー管理画面にアクセスするとタスク一覧画面にリダイレクトされること' do
          expect(page).not_to have_content 'ユーザー管理画面'
          visit admin_users_path
          expect(page).to have_content 'タスク一覧'
        end
      end
    end
  
    describe 'ユーザー詳細機能' do
      context '管理者としてログインした場合' do
        let(:login_user) { user1 }      
        it '他ユーザー詳細画面に遷移可能であること' do
          click_on 'ユーザー管理画面'

          #テストデータuser3の詳細ページに正しく遷移すること確認
          within('tr#user_no3') do
            click_on '詳細'
          end
          expect(page).to have_content "#{user3.name}さんのタスク一覧"
        end
      end
    end

    describe 'ユーザー編集機能' do
      context '管理者としてログインした場合' do
        let(:login_user) { user1 }      
        it 'ユーザー編集機能が正しく動作すること' do
          click_on 'ユーザー管理画面'
          
          #テストデータuser3の編集ページへ遷移
          within('tr#user_no3') do
            click_on '編集'
          end
          fill_in 'ユーザー名', with: 'user33'
          select '管理者', from: 'user_admin' #HTML上でid確認した    
          click_on '更新する'
          within('tr#user_no3') do
            expect(page).to have_content "user33"
            expect(page).to have_content "管理者"
          end
        end
      end
    end

    describe 'ユーザー削除機能' do
      context '一般ユーザーを削除する場合' do
        let(:login_user) { user1 }
        it 'ユーザーが削除され、該当ユーザーのタスクも削除されていること' do
          #user4のタスクを作成しておく
          FactoryBot.create(:fourth_task, user: user4)
          click_on 'ユーザー管理画面'
          
          #user4を削除
          within('#user_no4') do
            click_on '削除'
          end      
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content "ユーザーuser4さんを削除しました"
          
          #active recordで検索結果、レコード存在しない場合は空の配列が戻り値になる
          #user4が削除されていること
          expect(User.where(name: 'user4').empty?).to be true
          
          #user4のタスクも同時に削除されていること
          expect(Task.where(task_name: 'task4').empty?).to be true
        end
      end

      context '別の管理者ユーザーを削除する場合' do
        #user1, user2の2名が管理者
        let(:login_user) { user1 }
        it '指定した管理者ユーザーが削除されること' do
          click_on 'ユーザー管理画面'
          #user2を削除
          within('tr#user_no2') do
            click_on '削除'
          end
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content "ユーザーuser2さんを削除しました"
          expect(User.where(name: 'user2').empty?).to be true
        end
      end

      context '管理者が自分１名しかいない時に自分自身を削除する場合' do #コールバックが正しく動作するか検証するテスト
        #user1, user2の2名が管理者
        let(:login_user) { user1 }
        it 'ユーザーが削除されないこと' do
          click_on 'ユーザー管理画面'
          #まずuser2を削除
          within('tr#user_no2') do
            click_on '削除'
          end
          page.driver.browser.switch_to.alert.accept

          within('tr#user_no1') do
            click_on '削除'
          end
          page.driver.browser.switch_to.alert.accept
          expect(User.where(name: 'user1').empty?).to be false
        end
      end
    end
  end
    
  describe 'ログイン時のアクセスコントロール機能' do
    
    let!(:task_user1) { FactoryBot.create(:task, user: user1) }
    let!(:task_user2) { FactoryBot.create(:second_task, user: user2) }
    let!(:task_user3) { FactoryBot.create(:third_task, user: user3) }
    let!(:task_user4) { FactoryBot.create(:fourth_task, user: user4) }

    before do
      visit new_session_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_on 'Log in'
    end
    
    context 'タスク一覧画面にアクセスした場合' do
      let(:login_user) {user3} #user3でログイン
      it '他ユーザーのタスクが表示されないこと' do
        expect(page).not_to have_content 'task1'
        expect(page).not_to have_content 'task2'
        expect(page).not_to have_content 'task4'
        expect(page).to have_content 'task3'
      end
    end

    context '他ユーザーのタスク詳細にアクセスしようとした場合' do
      let(:login_user) {user3}
      it 'タスク一覧画面にリダイレクトされること' do
        visit task_path(task_user1.id)
        expect(page).to have_content 'タスク一覧'
      end
    end

    context '他ユーザーのタスク編集にアクセスしようとした場合' do
      let(:login_user) {user3}
      it 'タスク一覧画面にリダイレクトされること' do
        visit edit_task_path(task_user1.id)
        expect(page).to have_content 'タスク一覧'
      end
    end
  end
end

