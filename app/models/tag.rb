class Tag < ApplicationRecord
  has_many :man_tags
  has_many :mans, through: :man_tags
end
