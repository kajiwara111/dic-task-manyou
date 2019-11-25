require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user1 = FactoryBot.build(:user) #正しく入力されたユーザー
    @invalid_user1 = FactoryBot.build(:invalid_user1) #名前が31文字以上
    @invalid_user2 = FactoryBot.build(:invalid_user2) #email アドレスが不正
    @invalid_user3 = FactoryBot.build(:invalid_user3) #passwordが6文字未満
  end

  it '正しく入力されたユーザーは有効' do
    expect(@user1).to be_valid
  end

  it 'nameが31文字以上であれば無効' do
    @invalid_user1.valid?
    expect(@invalid_user1.errors[:name]).to include('は30文字以内で入力してください')
  end

  it '不正な形式のメールアドレスは無効' do
    @invalid_user2.valid?
    expect(@invalid_user2.errors[:email]).to include('は不正な値です')
  end

  it 'パスワードが6文字未満であれば無効' do
    @invalid_user3.valid?
    expect(@invalid_user3.errors[:password]).to include('は6文字以上で入力してください')
  end
end
