class ErrorsController < ApplicationController
  def not_found
    @joke = Joke.random || Joke.order('hot DESC').first
    redirect_to joke_path(@joke), status: 302    
  end 
end