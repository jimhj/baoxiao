class JokesController < ApplicationController
  def index
  end
  
  def show
    @joke = Joke.find(params[:id])
  end

  def hot
    @jokes = Joke.order('created_at DESC').paginate(page_opts)
    render_index
  end

  def search
    @jokes = Joke.search_with_hightlight(params[:q])
                 .paginate(page: params[:page], per_page: 20).results
    
  end  

  def qiubai
    find_jokes 'QB'
  end

  def mahua
    find_jokes 'MH'
  end

  private

  def find_jokes(type)
    @jokes = Joke.order('created_at DESC').where(from: type).paginate(page_opts)
    render_index
  end

  def render_index
    render template: 'index/index'
  end

  def page_opts
    { page: params[:page], per_page: 20, total_entries: 500 }
  end
end