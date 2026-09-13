class Tweet < ApplicationRecord
    belongs_to :user

    has_many :travel_days, dependent: :destroy

    has_many :collaborations, dependent: :destroy

    has_many :collaborators,
            through: :collaborations,
            source: :user

    has_one_attached :thumbnail

    validates :title, presence: true
    validates :s_date, presence: true
    validates :f_date, presence: true

    validate :f_date_must_be_after_s_date
    validate :thumbnail_must_be_image
    validate :thumbnail_size

    # そのユーザーが旅行のオーナーか判定
    def owned_by?(target_user)
        user == target_user
    end

  # そのユーザーが旅行を編集できるか判定
    def editable_by?(target_user)
        return false if target_user.nil?

        owned_by?(target_user) ||
        collaborators.exists?(id: target_user.id)
    end

 private

    def f_date_must_be_after_s_date
        return if s_date.blank? || f_date.blank?

        if f_date < s_date
            errors.add(:f_date, "は旅行開始日以降にしてください")
        end
    end

    def thumbnail_must_be_image
        return unless thumbnail.attached?

    unless thumbnail.content_type.in?(
        ["image/jpeg", "image/png", "image/webp"]
        )
        errors.add(
            :thumbnail,
            "はJPEG・PNG・WebP形式にしてください"
        )
        end
    end

    def thumbnail_size
        return unless thumbnail.attached?

        if thumbnail.blob.byte_size > 10.megabytes
            errors.add(:thumbnail, "は10MB以下にしてください")
        end
    end
end