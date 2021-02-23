require 'rails_helper'

RSpec.describe Message, type: :model do
  before do
    @message = FactoryBot.build(:message)
  end

  describe 'メッセージ送信機能' do
    context 'メッセージ送信がうまくいくとき' do
      it 'textが存在すれば保存できる' do
        expect(@message).to be_valid
      end
    end

    context 'メッセージ送信がうまくいかないとき' do
      it 'textが空だと保存できない' do
        @message.text = nil
        @message.valid?
        expect(@message.errors.full_messages).to include('Textを入力してください')
      end

      it 'roomが紐付いていないと保存できない' do
        @message.room = nil
        @message.valid?
        expect(@message.errors.full_messages).to include('Roomを入力してください')
      end

      it 'userが紐付いていないと保存できない' do
        @message.user = nil
        @message.valid?
        expect(@message.errors.full_messages).to include('Userを入力してください')
      end
    end
  end
end
