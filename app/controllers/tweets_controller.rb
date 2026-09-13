class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :check_editor, only: [:show, :edit, :update]
  before_action :check_owner, only: [:destroy]

  def new
    @tweet = current_user.tweets.new
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)

    if @tweet.save
      create_travel_days(@tweet)

      redirect_to tweet_path(@tweet),
                  notice: "旅行を投稿しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @travel_days = @tweet.travel_days
                          .includes(:schedules)
                          .order(:date)
    @collaborations = @tweet.collaborations
                            .includes(:user)
                            .order(:created_at)
  end

  def edit
  end

  def update
    if @tweet.update(tweet_params)
      synchronize_travel_days(@tweet)

      redirect_to tweet_path(@tweet),
                  notice: "旅行情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tweet.destroy

    redirect_to mypage_path,
                notice: "旅行の記録を削除しました",
                status: :see_other
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def check_editor
    return if @tweet.editable_by?(current_user)

    redirect_to mypage_path,
                alert: "この旅行を閲覧・編集する権限がありません"
  end

  def check_owner
    return if @tweet.owned_by?(current_user)

    redirect_to tweet_path(@tweet),
                alert: "旅行全体を削除できるのはオーナーだけです"
  end

  def tweet_params
    params.require(:tweet).permit(
      :title,
      :s_date,
      :f_date,
      :about,
      :thumbnail
    )
  end

  def create_travel_days(tweet)
    (tweet.s_date..tweet.f_date).each_with_index do |date, index|
      tweet.travel_days.create!(
        date: date,
        day_number: index + 1
      )
    end
  end

  def synchronize_travel_days(tweet)
    travel_dates = (tweet.s_date..tweet.f_date).to_a

    # 新しく範囲に入った日付を作成
    travel_dates.each do |date|
      tweet.travel_days.find_or_create_by!(date: date)
    end

    # 旅行期間外になった日付を削除
    tweet.travel_days.where.not(date: travel_dates).destroy_all

    # 1日目、2日目などの番号を振り直す
    tweet.travel_days.order(:date).each_with_index do |travel_day, index|
      travel_day.update!(day_number: index + 1)
    end
  end
end