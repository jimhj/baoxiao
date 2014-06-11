Rails.application.routes.draw do
  root to: 'index#index'

  get 'sign_up', to: 'users#new', as: 'sign_up'
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :jokes do
    collection do
      get :qiubai
      get :mahua
      get :hot
      get :search
    end
  end

  resources :users, only: [:create, :show] do
    collection do
      get :check_email
      get :check_name
    end
  end
end
