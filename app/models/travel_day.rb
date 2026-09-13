class TravelDay < ApplicationRecord
  belongs_to :tweet

  has_many :schedules, dependent: :destroy

  validates :date, presence: true
  validates :day_number, presence: true
end
