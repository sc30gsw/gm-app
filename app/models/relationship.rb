class Relationship < ApplicationRecord
  with_options presence: true do
    validates :user_id
    validates :follow_id
  end

  belongs_to :user
  belongs_to :follow, class_name: 'User'
end
