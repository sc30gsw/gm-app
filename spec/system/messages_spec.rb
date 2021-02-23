require 'rails_helper'

RSpec.describe 'メッセージ投稿機能', type: :system do
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

RSpec.describe 'メッセージ削除機能', type: :system do
  before do
    @entry1 = FactoryBot.create(:entry)
    @entry2 = FactoryBot.create(:entry)
  end

  it 'ログインしたユーザーはメッセージの削除ができ、削除に成功するとチャットルームに遷移する' do
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
    # メッセージに「削除」ボタンがあることを確認する
    find('.room-list-text').hover
    # 削除ボタンを押すと、Messageモデルのカウントが1減ることを確認する
    expect do
      find('.message-delete-btn').click
    end.to change { Message.count }.by(-1)
    # メッセージを削除するとチャットルームに遷移することを確認する
    expect(page).to have_selector('.room-user-card')
  end
end

RSpec.describe 'チャットルームの削除機能', type: :system do
  before do
    @entry1 = FactoryBot.create(:entry)
    @entry2 = FactoryBot.create(:entry)
  end

  it 'チャットルームを削除すると、関連するメッセージがすべて削除されていること' do
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
    # メッセージ情報を3つ追加する
    post1 = 'test'
    fill_in 'message_text', with: post1
    find('.room-message-btn').click
    post2 = 'test'
    fill_in 'message_text', with: post2
    find('.room-message-btn').click
    post3 = 'test'
    fill_in 'message_text', with: post3
    find('.room-message-btn').click
    # チャットルームのドロップダウンをクリックする
    find('.room-dropdown').click
    # 「チャットを終了する」ボタンがることを確認する
    expect(page).to have_content('チャットを終了する')
    # 「チャットを終了する」ボタンをクリックすることで、作成した5つのメッセージが削除されていることを確認する
    expect do
      find('.room-delete-item').click
    end.to change { Message.count }.by(-3)
    # entry2のマイページに遷移することを確認する
    expect(current_path).to eq user_path(@entry2.user)
  end
end
