require 'rails_helper'

RSpec.describe "新規投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @man = FactoryBot.build(:man)
  end

  context '新規投稿がうまくいくとき' do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      sign_in(@user)
      # トップページにユーザーのドロップダウンメニューがあることを確認する
      expect(page).to have_selector('.btn-header-drop')
      # ドロップダウンメニューをクリックする
      find('.btn-header-drop').click
      # 新規投稿ページに遷移するボタンがあることを確認する
      expect(page).to have_content('投稿する')
      # 投稿ページに遷移する
      visit new_man_path
      # フォームに情報を入力する
      fill_in 'man_name', with: @man.name
      find("#man_category_id").find("option[value='2']").select_option
      fill_in 'address', with: @man.address
      fill_in 'man_content', with: @man.content
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('man[image]', image_path, make_visible: true)
      # 送信するとManモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Man.count }.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq root_path
      # トップページは先ほど投稿した内容(name)が存在する
      expect(page).to have_content(@man.name)
    end
  end

  context '新規投稿がうまくいかないとき' do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # トップページにユーザーのドロップダウンメニューがあることを確認する
      expect(page).to have_selector('.btn-header-drop')
      # ドロップダウンメニューをクリックする
      find('.btn-header-drop').click
      # 新規投稿ページに遷移するボタンがないことを確認する
      expect(page).to have_no_content('投稿する')
    end
  end
end
