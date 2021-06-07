Rails.application.routes.draw do

  resources :users, only: %i(index new create show)

  resources :goals
  
  resource :session, only: %i(new create destroy)

  root to: 'users#index'
end
