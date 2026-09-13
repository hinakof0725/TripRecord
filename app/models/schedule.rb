class Schedule < ApplicationRecord
  belongs_to :travel_day

  has_one_attached :image

  validates :start_time, presence: true
  validates :place, presence: true
  validates :activity, presence: true

  validate :image_must_be_valid
  validate :image_size

  private

  def image_must_be_valid
    return unless image.attached?

    unless image.content_type.in?(
      ["image/jpeg", "image/png", "image/webp"]
      )
      errors.add(
      :image,
        "はJPEG・PNG・WebP形式にしてください"
      )
    end
  end

  def image_size
    return unless image.attached?

    if image.blob.byte_size > 10.megabytes
      errors.add(:image, "は10MB以下にしてください")
    end
  end
end