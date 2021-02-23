require 'rails_helper'

RSpec.describe "メッセージ投稿機能", type: :system do
  before do
    @entry1 = FactoryBot.create(:entry)
    @entry2 = FactoryBot.create(:entry)
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、チャットページに遷移して投稿した内容が表示されている' do
      # entry1でログインする
      sign_in(@entry1.user)
      # entry2のマイページに遷移する
      visit user_path(@entry2.user)
      # entry2のマイページにはチャットルームへ遷移するためのボタンがあることを確認する
      expect(page).to have_selector('.dm-submit-btn')
      # チャットルームに遷移するボタンを押す
      find('.dm-submit-btn').click
      # チャットルームへ遷移したことを確認する
      expect(page).to have_selector('.room-user-card')
      # 値をテキストフォームに入力する
      post = 'test'
      fill_in 'message_text', with: post
      # 送信ボタンを押すと、Messageモデルのカウントが1上がることを確認する
      expect do
        find('.room-message-btn').click
      end.to change { Message.count }.by(1)
      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)
    end
  end

  context '投稿できないとき' do
    it '送る値が空のためメッセージの送信に失敗すること' do
      # entry1でログインする
      sign_in(@entry1.user)
      # entry2のマイページに遷移する
      visit user_path(@entry2.user)
      # entry2のマイページにはチャットルームへ遷移するためのボタンがあることを確認する
      expect(page).to have_selector('.dm-submit-btn')
      # チャットルームに遷移するボタンを押す
      find('.dm-submit-btn').click
      # チャットルームへ遷移したことを確認する
      expect(page).to have_selector('.room-user-card')
      # 送信ボタンを押しても、Messageモデルのカウントが上がらないことを確認する
      expect do
        find('.room-message-btn').click
      end.not_to change { Message.count }
      # 元のページに戻ってくることを確認する
      expect(page).to have_selector('.room-user-card')
    end

    it 'ログインしていないとチャットルームに遷移するボタンがない' do
      # entry1のマイページに遷移する
      visit user_path(@entry1.user)
      # チャットルームに遷移するボタンが存在しないことを確認する
      expect(page).to have_no_selector('.dm-submit-btn')
    end
  end
end
