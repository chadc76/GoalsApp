Rails.application.routes.draw do
  resources :users, only: %i(new create show)
  
  resource :session, only: %i(new create destroy)

end
