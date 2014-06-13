class TagsController < ApplicationController
  def index
    @tags = Joke.tag_counts_on(:tags)
  end

  def show
    @jokes = Joke.tagged_with(params[:id]).order('id DESC').paginate(page: params[:page], per_page: 20, total_entries: 2000)
  end
end