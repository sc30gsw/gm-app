class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :man

  validates :text, presence: true
end
