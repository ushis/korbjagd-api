Rails.application.routes.draw do
  match '*path', controller: :application, action: :options, via: :options

  namespace :v1 do
    resource  :password_reset, only: [:create, :update]
    resources :sessions,       only: [:create]
    resources :categories,     only: [:index]

    resource  :profile, only: [:show, :create, :update, :destroy] do
      resource :avatar,       only: [:show, :create, :update, :destroy]
      resource :delete_token, only: [:create]
    end

    resources :sectors, only: [] do
      resources :baskets, only: [:index]
    end

    resources :baskets, only: [:show, :create, :update, :destroy] do
      resource  :photo,    only: [:show, :create, :update, :destroy]
      resources :comments, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
