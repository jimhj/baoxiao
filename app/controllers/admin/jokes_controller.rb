class Admin::JokesController < Admin::ApplicationController
  before_action :find_joke, except: [:index]

  def index
    @jokes = Joke.unscoped.includes(:user).order('id DESC').paginate(page: params[:page], per_page: 20, total_entries: 1000)   
  end

  def show
  end

  def approve
    @joke.approved!
  end

  def reject
    @joke.rejected!
  end

  def recommend
    @joke.update_attribute :recommended, true

  end

  def unrecommend
    @joke.update_attribute :recommended, false
   
  end

  private

  def find_joke
    @joke = Joke.unscoped.find params[:id]
  end

  def expire_recommends_cache
    expire_fragment 'jokes/recommends_1'
    expire_fragment 'jokes/recommends_2'
  end
end