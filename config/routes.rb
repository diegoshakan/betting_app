Rails.application.routes.draw do
  devise_for :users
  root "rounds#index"
  resources :teams, only: [ :index, :new, :create, :edit, :update ]
  resources :rounds, only: [ :index, :show, :new, :create ] do
    resources :bets, only: [ :new, :create, :edit, :update ]
    member do
      patch :update_status
    end
  end
  get "/bets", to: "bets#index", as: "all_bets"
  get "/bets/user/:user_id", to: "bets#show_user_bets", as: "user_bets"
end
