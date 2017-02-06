Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    resources :users, only: [:create, :show] do
      resources :deposits, only: [:create]
    end
    resource :session, only: [:create, :destroy]
    resources :trades, only: [:create]
  end
end
