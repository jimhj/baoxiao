class TagsController < ApplicationController
  caches_action :index, :expires_in => 1.hour

  def index
    @tags = Joke.tag_counts_on(:tags).order('taggings_count DESC')
    set_seo_meta "#{t('indexs.tags')}_#{Settings.app_title}"
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find_by(name: params[:id])
    @jokes = Joke.tagged_with(params[:id]).order('id DESC').paginate(page: params[:page], per_page: 20, total_entries: 2000)

    page_title = "#{t('tags.meta.title', tag: params[:id])},#{Settings.app_title}"
    description = "#{t('tags.meta.description', tag: @tag.description)}"
    set_seo_meta page_title, params[:id], description
  end
end