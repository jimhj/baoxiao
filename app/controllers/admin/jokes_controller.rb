class Admin::JokesController < Admin::ApplicationController
  def index
    @jokes = Joke.includes(:user).order('id DESC').paginate(page: params[:page], per_page: 20, total_entries: 1000)   
  end

  def show
    
  end
end