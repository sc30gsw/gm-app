class Like < ApplicationRecord
  belongs_to :user
  belongs_to :man
  validates_uniquenes_of :man_id, scope: :user_id
end
