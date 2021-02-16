class Man < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  extend ActiveHash::Associations::ActiveRecordExtensions
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy
  has_many :man_tags
  has_many :tags, through: :man_tags
  belongs_to :user
  belongs_to :category

  validates :category_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :tagbody, length: { maximum: 60 }
  with_options presence: true do
    validates :name
    validates :category_id
    validates :address
    validates :latitude
    validates :longitude
  end

  after_create do
    man = Man.find_by(id: id)
    tags = tagbody.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    tags.uniq.map do |tag|
      t = Tag.find_or_create_by(name: tag.downcase.delete('#'))
      man.tags << t
    end
  end

  before_update do
    man = Man.find_by(id: id)
    man.tags.clear
    tags = tagbody.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    tags.uniq.map do |tag|
      t = Tag.find_or_create_by(name: tag.downcase.delete('#'))
      man.tags << t
    end
  end

  def create_notification_like(current_user)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and man_id = ? and action = ? ', current_user.id, user_id, id, 'like'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        man_id: id,
        visited_id: user_id,
        action: 'like'
      )
      notification.checked = true if notification.visitor_id == notification.visited_id
      notification.save if notification.valid?
    end
  end

  def create_notification_comment(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(man_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      man_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end