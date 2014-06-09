class IndexController < ApplicationController

  def index
    @jokes = Joke.order('created_at DESC')
                 .paginate(:page => params[:page], :per_page => 20, total_entries: 500)
  end

end