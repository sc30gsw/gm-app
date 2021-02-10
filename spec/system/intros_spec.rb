require 'rails_helper'

RSpec.describe "プロフィール新規投稿", type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @intro = FactoryBot.build(:intro)
  end

  context '新規投稿がうまくいくとき' do
    it 'ログインしたユーザーは新規投稿ができる' do
      # user1でログインする
      sign_in(@user1)
      # トップページにユーザーのドロップダウンメニューがあることを確認する
      expect(page).to have_selector('.btn-header-drop')
      # ドロップダウンメニューをクリックする
      find('.btn-header-drop').click
      # マイページへ遷移するボタンがあることを確認する
      expect(page).to have_content('マイページへ行く')
      # マイページへ遷移する
      visit user_path(@user1)
      # user1のマイページへ遷移するとプロフィール編集ボタンがあることを確認する
      expect(page).to have_content('プロフィールを編集する')
      # プロフィール新規投稿ページに遷移する
      visit new_intro_path
      # プロフィール情報を入力する
      fill_in 'intro_profile', with: @intro.profile
      fill_in 'intro_website', with: @intro.website
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('intro[image]', image_path, make_visible: true)
      # 送信するとIntroモデルのカウントが1上がる
      expect do
        find('input[name="commit"]').click
      end.to change { Intro.count }.by(1)
      # user1のマイページに遷移することを確認する
      expect(current_path).to eq user_path(@user1)
      # user1のマイページには先ほど投稿した画像が存在する
      expect(page).to have_selector("img[src$='test_image.png']")
      # user1のマイページには先ほど投稿した内容が存在する
      expect(page).to have_content(@intro.profile)
      expect(page).to have_link(@intro.website)
    end
  end

  context '新規投稿がうまくいかないとき' do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページにいる
      visit root_path
      # トップページにユーザーのドロップダウンメニューがあることを確認する
      expect(page).to have_selector('.btn-header-drop')
      # ドロップダウンメニューをクリックする
      find('.btn-header-drop').click
      # マイページへ遷移するボタンがない
      expect(page).to have_no_content('マイページへ行く')
    end

    it 'user2のマイページに遷移してもプロフィール編集ボタンがない' do
      # user1でログインする
      sign_in(@user1)
      # user2のマイページに遷移する
      visit user_path(@user2)
      # user2のマイページに遷移してもプロフィール編集ボタンがないことを確認する
      expect(page).to have_no_content('プロフィールを編集する')
    end
  end
end
