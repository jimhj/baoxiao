class Admin::JokesController < Admin::ApplicationController
  before_action :find_joke, except: [:index, :search, :new, :create]

  ActsAsTaggableOn.delimiter = [',', '，']

  def index
    @jokes = Joke.unscoped.includes(:user).order('id DESC').paginate(page: params[:page], per_page: 20, total_entries: 1000)   
  end

  def new
    @joke = current_user.jokes.new
  end

  def create
    tag_list = joke_params.delete(:tag_list)
    @joke = current_user.jokes.build joke_params
    if @joke.save
      tag_list = tag_list.split(',').uniq.compact
      current_user.tag(@joke, with: tag_list, on: :tags)      
      redirect_to :back
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    picture = joke_params.delete(:picture)
    tag_list = joke_params.delete(:tag_list)

    if @joke.update_attributes joke_params
      if picture
        @joke.picture = picture
        @joke.save
      end

      if !tag_list.blank?
        @joke.tags.destroy_all
        tag_list = tag_list.split(',').uniq.compact
        current_user.tag(@joke, with: tag_list, on: :tags)
      end
      redirect_to :back
    else
      render :edit
    end
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

  def search
    @jokes = Joke.unscoped.search_with_hightlight(params[:q])
                 .paginate(page: params[:page], per_page: 20).records
    render template: 'admin/jokes/index'    
  end

  private

  def find_joke
    @joke = Joke.unscoped.find params[:id]
  end

  def joke_params
    params.require(:joke).permit(:title, :content, :picture, :tag_list, :recommended, :anonymous)
  end

  def expire_recommends_cache
    expire_fragment 'jokes/recommends_1'
    expire_fragment 'jokes/recommends_2'
  end
end