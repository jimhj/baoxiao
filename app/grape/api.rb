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
  end
end