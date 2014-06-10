class JokesController < ApplicationController
  def index
  end
  
  def show
    @joke = Joke.find(params[:id])
  end

  def hot
    @jokes = Joke.order('created_at DESC')
                 .paginate(:page => params[:page], :per_page => 20, total_entries: 500)
    render template: 'index/index'
  end

  def qiubai
    find_jokes 'QB'
  end

  def mahua
    find_jokes 'MH'
  end

  private

  def find_jokes(type)
    @jokes = Joke.order('created_at DESC')
    @jokes = @jokes.where(from: type)
    @jokes = @jokes.paginate(:page => params[:page], :per_page => 20, total_entries: 500)
    render template: 'index/index'
  end  
end