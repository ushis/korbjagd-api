Rails.application.routes.draw do
  match '*path', controller: :application, action: :options,  via: :options

  namespace :v1 do
    resource  :profile,        only: [:show, :update, :destroy]
    resource  :password_reset, only: [:create]
    resources :sessions,       only: [:create]
    resources :categories,     only: [:index]

    resources :users do
      resource :avatar, only: [:show, :create, :update, :destroy]
    end

    resources :baskets do
      resources :comments
      resource  :photo, only: [:show, :create, :update, :destroy]
    end
  end
end
