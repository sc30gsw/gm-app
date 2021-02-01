class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]

  with_options presence: true do
    validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{6,100}+\z/i, message: 'は英数字6文字以上で入力してください' }
    validates :nickname
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com', nickname: 'guest') do |user|
      user.password = ENV['USER_PASSWORD']
    end
  end
end
