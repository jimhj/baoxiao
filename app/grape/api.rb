require "entities"

module Baoxiao
  class API < Grape::API
    prefix "api"
    default_error_formatter :json
    
    resources :jokes do
      get do
        @jokes = Joke.includes(:user)
                     .order('id DESC')
                     .paginate(page: params[:page] || 1, per_page: params[:per_page] || 20, total_entries: 2000)

        present @jokes, :with => APIEntities::Joke
      end      
    end

    resources :users do
      post :sign_in do
        user = User.where(email: params[:email].downcase).first
        if user && user.authenticate(params[:password])
          user.ensure_private_token!
          present user, with: APIEntities::User, private_token: :show       
        else
          error!({ "error" => "邮箱或者密码错误" }, 201)
        end
      end
    end

  end
end