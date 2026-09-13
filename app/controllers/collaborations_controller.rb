class CollaborationsController < ApplicationController
    before_action :set_tweet
    before_action :check_owner

    def create
    email = params[:email].to_s.strip.downcase
    collaborator = User.find_by(email: email)

    if email.blank?
        redirect_to tweet_path(@tweet),
                    alert: "メールアドレスを入力してください"

    elsif collaborator.nil?
        redirect_to tweet_path(@tweet),
                    alert: "登録されているユーザーが見つかりません"

    elsif collaborator == @tweet.user
        redirect_to tweet_path(@tweet),
                    alert: "オーナー自身は共同編集者に追加できません"

    elsif @tweet.collaborators.exists?(id: collaborator.id)
        redirect_to tweet_path(@tweet),
                    alert: "このユーザーはすでに共同編集者です"

    else
        @tweet.collaborations.create!(user: collaborator)

        redirect_to tweet_path(@tweet),
                    notice: "#{collaborator.email}を共同編集者に追加しました"
    end
    end

    def destroy
    collaboration = @tweet.collaborations.find(params[:id])
    collaborator_email = collaboration.user.email

    collaboration.destroy

    redirect_to tweet_path(@tweet),
                notice: "#{collaborator_email}を共同編集者から解除しました",
                status: :see_other
    end

    private

    def set_tweet
    @tweet = current_user.tweets.find(params[:tweet_id])
    end

    def check_owner
    return if @tweet.owned_by?(current_user)

    redirect_to mypage_path,
                alert: "共同編集者を変更する権限がありません"
    end
end
