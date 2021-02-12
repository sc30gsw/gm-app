class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]

  with_options presence: true do
    validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{6,100}+\z/i, message: 'は英数字6文字以上で入力してください' }
    validates :nickname
  end

  has_one :intro
  has_many :sns_credentials
  has_many :mans
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :liked_mans, through: :likes, source: :man
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationsihps, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationsihps, source: :user

  def self.guest
    find_or_create_by!(email: 'guest@example.com', nickname: 'guest') do |user|
      user.password = ENV['USER_PASSWORD']
    end
  end

  def self.from_omniauth(auth)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    user = User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
      email: auth.info.email
    )
    if user.persisted?
      sns.user = user
      sns.save
    end
    { user: user, sns: sns }
  end

  def already_liked?(man)
    likes.exists?(man_id: man.id)
  end

  def follow(other_user)
    unless self == other_user
      self.relationships,find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
end
