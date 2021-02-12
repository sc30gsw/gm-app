class Relationship < ApplicationRecord
  with_options presence: true do
    validates :user_id
    validates :follow_id
  end
end
