class IndexController < ApplicationController

  def index
    @jokes = Joke.includes(:user).order('id DESC')
                                 .paginate(page: params[:page], per_page: 20, total_entries: 2000)
  end

end