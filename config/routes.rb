Rails.application.routes.draw do
  namespace :v1 do
    resource  :profile,    only: [:show, :update, :destroy]
    resources :sessions,   only: [:create]
    resources :categories, only: [:index]
    resources :users

    resources :baskets do
      resources :comments
    end
  end
end
