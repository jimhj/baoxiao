class IndexController < ApplicationController
  def index
    @jokes = Joke.paginate(:page => params[:page], :per_page => 20, total_entries: 3000)
                 .order('created_at DESC')
  end
end