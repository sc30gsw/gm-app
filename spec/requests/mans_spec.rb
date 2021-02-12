require 'rails_helper'

RSpec.describe 'Mans', type: :request do
  before do
    @man = FactoryBot.create(:man)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返っている' do
      get root_path
      expect(response.status).to eq 200
    end

    it 'indexアクションにリクエストするとレスポンスに投稿済みの内容が存在する(name)' do
      get root_path
      expect(response.body).to include @man.name
    end

    it 'indexアクションにリクエストするとレスポンスに投稿済みの内容が存在する(category.name)' do
      get root_path
      expect(response.body).to include @man.category.name
    end

    it 'indexアクションにリクエストするとキャッチコピーが存在する' do
      get root_path
      expect(response.body).to include 'あの偉人に会いに行こう'
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get man_path(@man)
      expect(response.status).to eq 200
    end

    it 'showアクションにリクエストするとレスポンスに投稿済みの内容が存在する(name)' do
      get man_path(@man)
      expect(response.body).to include @man.name
    end

    it 'showアクションにリクエストするとレスポンスにGoogleMapが存在する' do
      get man_path(@man)
      expect(response.body).to include('.map')
    end

    it 'showアクションにリクエストするとレスポンスにコメント入力部分が存在する' do
      get man_path(@man)
      expect(response.body).to include('コメント')
    end
  end
end
