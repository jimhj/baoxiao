class JokesController < ApplicationController
  before_action :login_required, only: [:new, :create]
  caches_action :feed, :hot, :recent, :cache_path => Proc.new { |c| c.params }, :expires_in => 30.minutes
  # caches_action :show, :expires_in => 1.day

  def new
    @joke = current_user.jokes.new
    @joke.anonymous = true
    set_seo_meta "#{t('indexs.new')}_#{Settings.app_title}" 
  end

  def create
    @joke = current_user.jokes.build joke_params
    if @joke.content.length < 20 && !@joke.picture.blank?
      @joke.title = @joke.content
      @joke.content = ""
    end

    if @joke.save
      redirect_to @joke
    else
      render :new
    end
  end

  def vote
    joke = Joke.find(params[:id])
    if login?
      return if current_user.voted_for?(joke)
      result = current_user.vote_for(joke, params[:vote_value])
    else
      joke.vote_by_anonymous params[:vote_value]
    end
    render json: { success: true }
  end
  
  def show
    @joke = Joke.find(params[:id])
    @tags = @joke.tags
    @comment = @joke.comments.new
    @comments = @joke.comments.order('id ASC')
    set_meta_data
    fresh_when(etag: @joke)
  end

  def random
    @joke = Joke.random || Joke.order('hot DESC').first
    redirect_to joke_path(@joke)
  end

  def rand
    @joke = Joke.recommends.sample || Joke.random || Joke.order('hot DESC').first
    redirect_to joke_path(@joke)
  end

  def duanzi
    @jokes = Joke.duanzi.paginate(page_opts)
    set_seo_meta "#{t('indexs.duanzi')}_#{Settings.app_title}"
  end

  def tupian
    @jokes = Joke.tupian.paginate(page_opts)
    set_seo_meta "#{t('indexs.tupian')}_#{Settings.app_title}"
  end

  def recent
    @jokes = Joke.includes(:user).order('id DESC')
                                 .paginate(page: params[:page], per_page: 20, total_entries: 2000)
    set_seo_meta "#{t('indexs.recent')}_#{Settings.app_title}" 
  end

  def hot
    @jokes = Joke.order('hot DESC').paginate(page_opts)
    set_seo_meta "#{t('indexs.hot')}_#{Settings.app_title}"
  end

  def feed
    @jokes = Joke.order('id DESC').limit(20)
    render layout: false
  end

  def search
    @results = Joke.search_with_hightlight(params[:q])
                 .paginate(page: params[:page], per_page: 20).results

    set_seo_meta "#{t('indexs.search')}_#{params[:q]}_#{Settings.app_title}"
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
    set_seo_meta
    render template: 'index/index'
  end

  def page_opts
    { page: params[:page], per_page: 20, total_entries: 2000 }
  end

  def joke_params
    params.require(:joke).permit(:title, :content, :picture, :anonymous)
  end

  def set_meta_data
    title = @joke.title.presence || @joke.content
    tag_list = @joke.tags.map(&:name)
    keywords = ([title] + tag_list).join(',')
    description = if @joke.title.blank?
      ([@joke.content] + tag_list).join(',')
    else
      ([title, @joke.content] + tag_list).join(',')
    end
    set_seo_meta title, keywords, description    
  end
end