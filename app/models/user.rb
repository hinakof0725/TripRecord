class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
          :registerable,
          :recoverable, 
          :rememberable, 
          :validatable

  # 自分がオーナーの旅行
  has_many :tweets, dependent: :destroy

  # 自分が共同編集者として参加している関係
  has_many :collaborations, dependent: :destroy

  # 自分が共同編集者として参加している旅行
  has_many :shared_tweets,
           through: :collaborations,
           source: :tweet
end
