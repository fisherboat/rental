Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :users, only: [:create, :show]
    resources :books, only: [:index, :show] do
      member do
        post :borrow
        post :repay
        get :actual_income
      end
    end
  end
end
