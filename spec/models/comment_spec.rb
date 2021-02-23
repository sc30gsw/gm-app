require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe 'コメント新規投稿' do
    context 'コメント新規投稿がうまくいくとき' do
      it 'すべての項目が存在すれば保存できる' do
        expect(@comment).to be_valid
      end
    end

    context 'コメント新規投稿がうまくいかないとき' do
      it 'textが空だと保存できない' do
        @comment.text = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Textを入力してください')
      end

      it 'userが紐付いていないと保尊できない' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Userを入力してください')
      end

      it 'manが紐付いていないと保尊できない' do
        @comment.man = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Manを入力してください')
      end
    end
  end
end
