Rails.application.routes.draw do

  resources :users, only: %i(index new create show)

  resources :goals do
    member do
      post 'toggle_complete'
    end
  end
  
  resource :session, only: %i(new create destroy)

  root to: 'users#index'
end
