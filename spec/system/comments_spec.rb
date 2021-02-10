require 'rails_helper'

RSpec.describe "コメント投稿", type: :system do
  before do
    @man = FactoryBot.create(:man)
    @comment = FactoryBot.build(:comment)
  end

  context 'コメント投稿できるとき' do
    it 'ログインしたユーザーは投稿詳細ページでコメント投稿できる' do
    # ログインする
    sign_in(@man.user)
    # トップページに投稿詳細ページへのリンクがある
    expect(page).to have_link(@man.name), href: man_path(@man)
    # 詳細ページに遷移する
    visit man_path(@man)
    # フォームに情報を入力する
    fill_in 'comment_text', with: @comment.text
    # コメントを送信すると、Commentモデルのカウントが1上がることを確認する
    expect {
      find('input[name="commit"]').click
    }.to change{ Comment.count }.by(1)
    # 詳細ページにリダイレクトされることを確認する
    expect(current_path).to eq man_path(@man)
    # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する
    expect(page).to have_content @comment.text
    end
  end

  context 'コメント投稿できないとき' do
    it 'ログインしていない状態で投稿詳細ページに遷移できるもののコメント投稿欄が表示せれない' do
      # トップページにいる
      visit root_path
      # トップページに投稿詳細ページへのリンクがある
      expect(page).to have_link(@man.name), href: man_path(@man)
      # 詳細ページに遷移する
      visit man_path(@man)
      # コメント用のフォームが存在しない
      expect(page).to have_no_selector('#comment_text')
      # 「ユーザー登録をしてコメントを書こう!」が表示されていることを確認する
      expect(page).to have_content('ユーザー登録をしてコメントを書こう！')
    end
  end
end
