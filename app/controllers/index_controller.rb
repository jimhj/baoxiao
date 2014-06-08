class IndexController < ApplicationController
  def index
    @jokes = Joke.all
  end
end