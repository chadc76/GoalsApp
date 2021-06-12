Rails.application.routes.draw do

  resources :users, only: %i(index new create show) do
    member do
      post :comment
    end
  end

  resources :goals do
    member do
      post :toggle_complete
      post :comment
    end
  end
  
  resource :session, only: %i(new create destroy)

  root to: 'users#index'
end
