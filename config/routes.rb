Rails.application.routes.draw do
  match '*path', controller: :application, action: :options,  via: :options

  namespace :v1 do
    resource  :profile,        only: [:show, :update, :destroy]
    resource  :password_reset, only: [:create, :update]
    resources :sessions,       only: [:create]
    resources :categories,     only: [:index]

    resources :users, only: [:index, :show, :create, :update, :destroy] do
      resource :avatar, only: [:show, :create, :update, :destroy]
    end

    resources :baskets, only: [:index, :show, :create, :update, :destroy] do
      resource  :photo,    only: [:show, :create, :update, :destroy]
      resources :comments, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
