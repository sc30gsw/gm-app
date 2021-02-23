require 'rails_helper'

RSpec.describe Man, type: :model do
  before do
    @man = FactoryBot.build(:man)
  end

  describe '新規投稿' do
    context '新規投稿がうまくいくとき' do
      it 'すべての項目が存在すれば保存できる' do
        expect(@man).to be_valid
      end

      it 'contentが存在しなくても保存できる' do
        @man.content = nil
        expect(@man).to be_valid
      end

      it '画像が存在しなくても保存できる' do
        @man.image = nil
        expect(@man).to be_valid
      end
    end

    context '新規投稿がうまくいかないとき' do
      it 'nameが空だと保存できない' do
        @man.name = nil
        @man.valid?
        expect(@man.errors.full_messages).to include('偉人の名前等を入力してください')
      end

      it 'category_idが空だと保存できない' do
        @man.category_id = nil
        @man.valid?
        expect(@man.errors.full_messages).to include('カテゴリーを選択してください')
      end

      it 'category_idの値が1だと保存できない' do
        @man.category_id = 1
        @man.valid?
        expect(@man.errors.full_messages).to include('カテゴリーを選択してください')
      end

      it 'addressが空だと保存できない' do
        @man.address = nil
        @man.valid?
        expect(@man.errors.full_messages).to include('マップ検索を入力してください')
      end

      it 'latitudeが空だと保存できない' do
        @man.latitude = nil
        @man.valid?
        expect(@man.errors.full_messages).to include('緯度を入力してください')
      end

      it 'longitudeが空だと保存できない' do
        @man.longitude = nil
        @man.valid?
        expect(@man.errors.full_messages).to include('経度を入力してください')
      end

      it 'userが紐付いていないと保尊できない' do
        @man.user = nil
        @man.valid?
        expect(@man.errors.full_messages).to include('Userを入力してください')
      end
    end
  end
end
