class Man < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  has_one_attached :image
  belongs_to :user
  belongs_to :category

  validates :category_id, numericality: {other_than: 1}
  with_options presence: true do
    validates :name
    validates :category_id
    validates :address
    validates :latitude
    validates :longtude
  end
end
