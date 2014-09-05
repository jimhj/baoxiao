require "entities"
require "helpers"

module Baoxiao
  class API < Grape::API
    prefix "api"
    default_error_formatter :json

    helpers APIHelpers
    
    resources :jokes do
      get do
        logger.info request.headers
        @jokes = Joke.includes(:user)
                     .order('id DESC')
                     .paginate(page: params[:page] || 1, per_page: params[:per_page] || 20, total_entries: 2000)

        present @jokes, :with => APIEntities::Joke
      end      
    end

    resources :users do
      post :sign_up do
      end

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

    resources :jokes do
      post do
        authenticate!
        joke = current_user.jokes.build
        joke.content = params[:content]
        joke.anonymous = false
        joke.user_agent = request.headers["User-Agent"]
        joke.from_client = true

        if joke.save
          present joke, :with => APIEntities::Joke
        else
          error!({ "error" => joke.errors.full_messages }, 400)
        end
      end
    end
  end
end