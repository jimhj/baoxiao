class JokesController < ApplicationController
  before_action :login_required, only: [:new, :create, :vote]

  def new
    @joke = current_user.jokes.new
  end

  def create
    @joke = current_user.jokes.build joke_params
    if @joke.save
      redirect_to @joke
    else
      render :new
    end
  end

  def vote
    joke = Joke.find(params[:id])
    return if current_user.voted_for?(joke)
    result = current_user.vote_for(joke, params[:vote_value])
    render json: { success: result }
  end
  
  def show
    @joke = Joke.find(params[:id])
  end

  def hot
    @jokes = Joke.order('hot DESC').paginate(page_opts)
    render template: 'index/index'
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

  def check_title
    respond_to do |format|
      format.json do
        render json: !Joke.where(title: params[:joke][:title]).where.not(id: params[:id]).exists?
      end
    end
  end

  def check_content
    respond_to do |format|
      format.json do
        render json: !Joke.where(content: params[:joke][:content]).where.not(id: params[:id]).exists?
      end
    end
  end  

  private

  def find_jokes(type)
    @jokes = Joke.order('id DESC').where(from: type).paginate(page_opts)
    render template: 'index/index'
  end

  def page_opts
    { page: params[:page], per_page: 20, total_entries: 20000 }
  end

  def joke_params
    params.require(:joke).permit(:title, :content, :picture, :anonymous)
  end
end