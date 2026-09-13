class Collaboration < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  validates :user_id,
              uniqueness: {
                scope: :tweet_id,
                message: "はすでに共同編集者です"
              }
end
