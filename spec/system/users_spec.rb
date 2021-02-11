require 'rails_helper'

RSpec.describe "新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページにユーザーのドロップダウンメニューがあることを確認する
      expect(page).to have_selector('.btn-header-drop')
      # ドロップダウンメニューをクリックする
      find('.btn-header-drop').click
      # サインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('登録する')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user_nickname', with: @user.nickname
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      fill_in 'user_password_confirmation', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change{ User.count }.by(1)
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # ドロップダウンメニューをクリックする
      find('.btn-header-drop').click
      # ログアウトボタンが表示されることを確認する
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('登録する')
      expect(page).to have_no_content('ログインする')
    end
  end

  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにユーザーのドロップダウンメニューがあることを確認する
      expect(page).to have_selector('.btn-header-drop')
      # ドロップダウンメニューをクリックする
      find('.btn-header-drop').click
      # サインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('登録する')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user_nickname', with: ""
      fill_in 'user_email', with: ""
      fill_in 'user_password', with: ""
      fill_in 'user_password_confirmation', with: ""
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change{ User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq "/users"
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインできるとき' do
    it '保存されているユーザーの情報と合致すればログインできる' do
      # トップページに移動する
      visit root_path
      # トップページにユーザーのドロップダウンメニューがあることを確認する
      expect(page).to have_selector('.btn-header-drop')
      # ドロップダウンメニューをクリックする
      find('.btn-header-drop').click
      # ログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログインする')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # ドロップダウンメニューをクリックする
      find('.btn-header-drop').click
      # ログアウトボタンが表示されることを確認する
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('登録する')
      expect(page).to have_no_content('ログインする')
    end
  end
  
  context 'ログインできないとき' do
    it '保存されているユーザーの情報と合致しなければログインできない' do
      # トップページに移動する
      visit root_path
      # トップページにユーザーのドロップダウンメニューがあることを確認する
      expect(page).to have_selector('.btn-header-drop')
      # ドロップダウンメニューをクリックする
      find('.btn-header-drop').click
      # ログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログインする')
      # ログインページへ遷移する
      visit new_user_session_path
      # 誤ったユーザー情報を入力する
      fill_in 'user_email', with: ""
      fill_in 'user_password', with: ""
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq new_user_session_path
    end
  end
end