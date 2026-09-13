class TravelDaysController < ApplicationController
  before_action :set_tweet
  before_action :check_owner
  before_action :set_travel_day

  def edit
  end

  def update
    if @travel_day.update(travel_day_params)
      redirect_to tweet_path(@tweet),
                  notice: "#{@travel_day.day_number}日目を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end

  def check_editor
    return if @tweet.editable_by?(current_user)

    redirect_to mypage_path,
                alert: "編集する権限がありません"
  end

  def set_travel_day
    @travel_day = @tweet.travel_days.find(params[:id])
  end

  def travel_day_params
    params.require(:travel_day).permit(
      :day_title,
      :memo
    )
  end
end
