class JokesController < ApplicationController
  def index
  end
  
  def show
    @joke = Joke.find params[:id]
  end
end