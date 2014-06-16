class Admin::TagsController < Admin::ApplicationController
  def index
    @tags = Joke.tag_counts_on(:tags).order('taggings_count DESC').paginate(page: params[:page], per_page: 50)
  end

  def jokes
    @jokes = Joke.includes(:user).tagged_with(params[:id]).order('id DESC').paginate(page: params[:page], per_page: 20)
    render template: 'admin/jokes/index'
  end
end