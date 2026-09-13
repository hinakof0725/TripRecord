Rails.application.routes.draw do
  devise_for :users

  root "home#top"

  get "mypage", to: "mypage#show"

  resources :tweets do
    resources :collaborations,
              only: [:create, :destroy]

  resources :travel_days,
              only: [:edit, :update] do
      resources :schedules,
                except: [:index, :show]
    end
  end
end