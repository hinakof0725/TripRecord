class MypageController < ApplicationController
  def show
    @tweets = current_user.tweets
                          .with_attached_thumbnail
                          .order(s_date: :desc)

    @shared_tweets = current_user.shared_tweets
                                 .with_attached_thumbnail
                                 .order(s_date: :desc)
  end
end
