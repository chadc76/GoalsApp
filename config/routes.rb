Rails.application.routes.draw do
  resource :homepage, only: [:index]

  resources :users, only: %i(new create show)
  
  resource :session, only: %i(new create destroy)

  root to: 'homepages#index'
end
