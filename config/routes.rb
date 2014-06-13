Rails.application.routes.draw do
  root to: 'index#index'

  get 'sign_up', to: 'users#new', as: 'sign_up'
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :jokes, except: [:index] do
    collection do
      get :qiubai
      get :mahua
      get :hot
      get :random
      get :search
      get :check_title
      get :check_content    
    end

    member do
      post :vote
    end
  end

  resources :users, only: [:create, :show] do
    collection do
      get :check_email
      get :check_name
    end
  end
end
