Rails.application.routes.draw do
  root to: 'index#index'

  get 'sign_up', to: 'users#new', as: 'sign_up'
  resources :jokes
  resources :users, only: [:create, :show] do
    collection do
      get :check_email
      get :check_name
    end
  end
end
