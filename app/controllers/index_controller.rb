class IndexController < ApplicationController
  def index
    @jokes = Joke.paginate(:page => params[:page], :per_page => 20)
  end
end