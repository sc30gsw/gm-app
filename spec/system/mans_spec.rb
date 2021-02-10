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

RSpec.describe "投稿詳細", type: :system do
  before do
    @man = FactoryBot.create(:man)
  end

  it 'ログインしたユーザーは投稿詳細ページに遷移してコメント投稿欄が表示される' do
    # ログインする
    sign_in(@man.user)
    # トップページに投稿詳細ページへのリンクがある
    expect(page).to have_link(@man.name), href: man_path(@man)
    # 詳細ページに遷移する
    visit man_path(@man)
    # 詳細ページには投稿内容が含まれている
    expect(page).to have_content(@man.name)
    expect(page).to have_content(@man.category_id)
    expect(page).to have_content(@man.content)
    expect(page).to have_selector("img[src$='test_image2.png']")
    # 投稿したGoogleMapが存在する
    expect(page).to have_selector('#map')
    # コメント用のフォームが存在する
    expect(page).to have_selector('#comment_text')
  end

  it 'ログインしていない状態で投稿詳細ページに遷移できるもののコメント投稿欄が表示せれない' do
    # トップページにいる
    visit root_path
    # トップページに投稿詳細ページへのリンクがある
    expect(page).to have_link(@man.name), href: man_path(@man)
    # 詳細ページに遷移する
    visit man_path(@man)
    # 詳細ページには投稿内容が含まれている
    expect(page).to have_content(@man.name)
    expect(page).to have_content(@man.category_id)
    expect(page).to have_content(@man.content)
    expect(page).to have_selector("img[src$='test_image2.png']")
    # 投稿したGoogleMapが存在する
    expect(page).to have_selector('#map')
    # コメント用のフォームが存在しない
    expect(page).to have_no_selector('#comment_text')
    # 「ユーザー登録をしてコメントを書こう!」が表示されていることを確認する
    expect(page).to have_content('ユーザー登録をしてコメントを書こう！')
  end
end

RSpec.describe '投稿編集', type: :system do
  before do
    @man1 = FactoryBot.create(:man)
    @man2 = FactoryBot.create(:man)
  end

  context '投稿編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿したmanの編集ができる' do
      # man1を投稿したユーザーでログインする
      sign_in(@man1.user)
      # トップページに投稿詳細ページへのリンクがある
      expect(page).to have_link(@man1.name), href: man_path(@man1)
      # 詳細ページに遷移する
      visit man_path(@man1)
      # man1に「編集」ボタンがあることを確認する
      expect(page).to have_link '編集する', href: edit_man_path(@man1)
      # 編集ページに遷移する
      visit edit_man_path(@man1)
      # 編集ページにはすでに投稿済みの内容が含まれていることを確認する
      expect(find('#man_name').value).to eq @man1.name
      expect(find('#address').value).to eq @man1.address
      expect(find('#man_content').value).to eq @man1.content
      # 投稿内容を編集する
      fill_in 'man_name', with: "#{@man1.name}name"
      find("#man_category_id").find("option[value='3']").select_option
      fill_in 'address', with: "マンハッタン"
      fill_in 'man_content', with: "#{@man1.content}content"
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('man[image]', image_path, make_visible: true)
      # 送信するとManモデルのカウントが上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Man.count }.by(0)
      # man1の詳細ページに遷移することを確認する
      expect(current_path).to eq man_path(@man1)
      # 詳細ページには先ほど編集した内容の投稿が存在する
      expect(page).to have_content(@man1.name)
      expect(page).to have_content(@man1.category_id)
      expect(page).to have_content(@man1.content)
      expect(page).to have_selector("img[src$='test_image.png']")
    end
  end

  context '投稿編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したmanの編集画面には遷移できない' do
      # man1を投稿したユーザーでログインする
      sign_in(@man1.user)
      # man2の詳細ページに遷移する
      visit man_path(@man2)
      # man2に編集ボタンがないことを確認する
      expect(page).to have_no_link '編集する', href: edit_man_path(@man2)
    end

    it 'ログインしていないと投稿編集画面には遷移できない(man1)' do
      # トップページにいる
      visit root_path
      # man1の詳細ページに遷移する
      visit man_path(@man1)
      # man1に編集ボタンがないことを確認する
      expect(page).to have_no_link '編集する', href: edit_man_path(@man1) 
    end

    it 'ログインしていないと投稿編集画面には遷移できない(man2)' do
      # トップページにいる
      visit root_path
      # man1の詳細ページに遷移する
      visit man_path(@man2)
      # man1に編集ボタンがないことを確認する
      expect(page).to have_no_link '編集する', href: edit_man_path(@man2) 
    end
  end
end

RSpec.describe '投稿削除', type: :system do
  before do
    @man1 = FactoryBot.create(:man)
    @man2 = FactoryBot.create(:man)
  end

  context '投稿削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿したmanを削除できる' do
      # man1を投稿したユーザーでログインする
      sign_in(@man1.user)
      # トップページに投稿詳細ページへのリンクがある
      expect(page).to have_link(@man1.name), href: man_path(@man1)
      # 詳細ページに遷移する
      visit man_path(@man1)
      # man1に「編集」ボタンがあることを確認する
      expect(page).to have_link '編集する', href: edit_man_path(@man1)
      # 編集ページに遷移する
      visit edit_man_path(@man1)
      # 「削除」ボタンがあることを確認する
      expect(page).to have_link '削除する', href: man_path(@man1)
      # 投稿を削除するとレコードの数が1減ることを確認する
      expect {
        find('.edit-delete-btn').click
      }.to change{ Man.count }.by(-1)
      # トップページに遷移することを確認する
      expect(current_path).to eq root_path
      # トップページにはman1内容が存在しないことを確認する
      expect(page).to have_no_content @man1.name
    end
  end

  context '投稿削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したmanを削除できない' do
      # man1を投稿したユーザーでログインする
      sign_in(@man1.user)
      # man2の詳細ページに遷移する
      visit man_path(@man2)
      # man2に編集ボタンがないことを確認する
      expect(page).to have_no_link '編集する', href: edit_man_path(@man2)
    end

    it 'ログインしていないと編集ページに遷移することができない(削除ボタンを押すことができない)(man1)' do
      # トップページにいる
      visit root_path
      # man1の詳細ページに遷移する
      visit man_path(@man1)
      # man1に編集ボタンがないことを確認する
      expect(page).to have_no_link '編集する', href: edit_man_path(@man1) 
    end

    it 'ログインしていないと編集ページに遷移することができない(削除ボタンを押すことができない)(man2)' do
      # トップページにいる
      visit root_path
      # man1の詳細ページに遷移する
      visit man_path(@man2)
      # man1に編集ボタンがないことを確認する
      expect(page).to have_no_link '編集する', href: edit_man_path(@man2) 
    end
  end
end