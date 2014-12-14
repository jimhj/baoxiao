require "entities"
require "helpers"

module Baoxiao
  class API < Grape::API
    prefix "api"
    default_error_formatter :json

    helpers APIHelpers
    
    before do
      logger.info request.headers
      logger.info params
    end

    resources :jokes do
      get do
        @jokes = Joke.includes(:user)
                     .order('id DESC')
                     .paginate(page: params[:page] || 1, per_page: params[:per_page] || 20, total_entries: 2000)

        present @jokes, :with => APIEntities::Joke
      end

      get :meinvmeitu do
        @jokes = Joke.includes(:user)
                     .tagged_with('美女')
                     .order('id DESC')
                     .paginate(page: params[:page] || 1, per_page: params[:per_page] || 20, total_entries: 2000)

        present @jokes, :with => APIEntities::Joke        
      end

      get :xieemanhua do
        @jokes = Joke.includes(:user)
                     .tagged_with('邪恶')
                     .order('id DESC')
                     .paginate(page: params[:page] || 1, per_page: params[:per_page] || 20, total_entries: 2000)

        present @jokes, :with => APIEntities::Joke        
      end

      get :youmoqiushi do
        @jokes = Joke.includes(:user)
                     .tagged_with('糗事')
                     .order('id DESC')
                     .paginate(page: params[:page] || 1, per_page: params[:per_page] || 20, total_entries: 2000)

        present @jokes, :with => APIEntities::Joke        
      end

      get :neihanduanzi do
        @jokes = Joke.includes(:user)
                     .tagged_with('内涵')
                     .order('id DESC')
                     .paginate(page: params[:page] || 1, per_page: params[:per_page] || 20, total_entries: 2000)

        present @jokes, :with => APIEntities::Joke        
      end

      get ":id/comments" do
        joke = Joke.find params[:id]
        comments = joke.comments.order('created_at ASC')
        present comments, with: APIEntities::Comment
      end                       
    end

    resources :users do
      post :sign_up do
        user = User.new
        user.email = params[:email]
        user.name = params[:name]
        user.password = params[:password]

        if user.save
          user.ensure_private_token!
          present user, with: APIEntities::User, private_token: :show
        else
          error!({ "error" => user.errors.full_messages.first }, 200)
        end
      end

      post :sign_in do
        user = User.where(email: params[:email].downcase).first
        if user && user.authenticate(params[:password])
          user.ensure_private_token!
          present user, with: APIEntities::User, private_token: :show       
        else
          error!({ "error" => "邮箱或者密码错误" }, 200)
        end
      end
    end

    resources :jokes do
      params do
        requires :token, type: String
      end

      post do
        authenticate!
        joke = current_user.jokes.build
        joke.content = params[:content]
        joke.anonymous = false
        joke.user_agent = request.headers["User-Agent"]
        joke.from_client = true

        unless params[:picture].blank?
          joke.picture = params[:picture]
        end

        if joke.save
          present joke, :with => APIEntities::Joke
        else
          error!({ "error" => joke.errors.full_messages.first }, 200)
        end
      end
    end
  end
end