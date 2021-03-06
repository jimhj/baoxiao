Rails.application.routes.draw do
  require 'api'
  mount Baoxiao::API => "/"

  root to: 'index#index'

  get 'privacy', to: 'privacy#index'
  get 'sign_up', to: 'users#new', as: 'sign_up'
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'auth/weibo/callback', to: 'auth#weibo_callback'
  get 'auth/qq/callback', to: 'auth#qq_callback'
  
  resources :jokes, except: [:index] do
    collection do
      get :qiubai
      get :mahua
      get :recent
      get :hot
      get :random
      get :rand
      get :duanzi
      get :tupian
      get :search
      get :check_title
      get :check_content
      get :feed, defaults: { format: 'xml' }  
    end

    member do
      post :vote
    end

    resources :comments, only: [:create, :destroy]
  end

  post 'comments/:id/like', to: 'comments#like', as: 'like_comment'

  resources :tags, only: [:index, :show]

  resources :users, only: [:create, :show] do
    collection do
      get :check_email
      get :check_name
      get :fetch_current_user_as_json
    end
  end

  namespace :settings do
    resource :profile, only: [:show, :update]
  end  

  scope 'ad', as: 'ad' do
    get :recommends, to: 'ad#recommends'
    get 'pics/:position', to: 'ad#pics', as: :pics
  end

  namespace :admin do
    root to: 'dashboard#index'
    resources :users

    resources :jokes do
      member do
        post :recommend
        delete :unrecommend
        post :approve
        post :reject
      end

      collection do
        get :search
      end
    end

    resources :tags do
      member do
        get :jokes
      end

      collection do
        get :search
      end
    end
    
    resources :ads

    resources :friend_sites
  end

  if Rails.env.production?
    get '/404' => 'errors#not_found'
  end
end
