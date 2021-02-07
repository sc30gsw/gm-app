class Like < ApplicationRecord
  belongs_to :user
  belongs_to :man
  validates_uniqueness_of :man_id, scope: :user_id
end
