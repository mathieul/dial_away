Rails.application.routes.draw do
  get 'home/index'
  root to: 'home#index'

  resources :users, only: [:new, :create, :show] do
    collection do
      get :show_verify
    end

    member do
      post :verify
      post :resend
    end
  end
end
