class SchedulesController < ApplicationController
    before_action :set_tweet
    before_action :check_editor
    before_action :set_travel_day
    before_action :set_schedule, only: [:edit, :update, :destroy]

    def new
        @schedule = @travel_day.schedules.new
    end

    def create
        @schedule = @travel_day.schedules.new(schedule_params)

        if @schedule.save
            redirect_to tweet_path(@tweet),
                        notice: "予定を追加しました"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @schedule.update(schedule_params)
            redirect_to tweet_path(@tweet),
                        notice: "予定を更新しました"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @schedule.destroy

        redirect_to tweet_path(@tweet),
                    notice: "予定を削除しました",
                    status: :see_other
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
        @travel_day = @tweet.travel_days.find(params[:travel_day_id])
    end

    def set_schedule
        @schedule = @travel_day.schedules.find(params[:id])
    end

    def schedule_params
        params.require(:schedule).permit(
            :start_time,
            :end_time,
            :place,
            :activity,
            :memo,
            :image
        )
    end
end
