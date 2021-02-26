class Tag < ApplicationRecord
  has_many :man_tags
  has_many :mans, through: :man_tags

  validates :name, uniqueness: true

  paginates_per 10
end
