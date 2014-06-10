class IndexController < ApplicationController

  def index
    @jokes = Joke.order('id DESC')
                 .paginate(:page => params[:page], :per_page => 20, total_entries: 500)
  end

end