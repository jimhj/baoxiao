class TagsController < ApplicationController
  caches_action :index, :show, :expires_in => 30.minutes, :cache_path => Proc.new { |c| c.params }

  def index
    @tags = Joke.tag_counts_on(:tags).order('taggings_count DESC')
    set_seo_meta "#{t('indexs.tags')}_#{Settings.app_title}"
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find_by(name: params[:id])
    @jokes = Joke.tagged_with(params[:id]).order('id DESC').paginate(page: params[:page], per_page: 20, total_entries: 2000)

    keywords = if @tag.keywords.blank?
      t('tags.meta.title', tag: params[:id])
    else
      @tag.keywords
    end

    page_title = "#{keywords.split(/,\s?|，\s?/).join('_')}_#{Settings.app_name}"

    description = if @tag.description.blank?
      @sample_joke = @jokes.where.not(content: nil).sample
      @sample_joke.try(:content) || t('tags.meta.description', tag: params[:id])
    else
      @tag.description
    end

    set_seo_meta page_title, keywords, description
  end
end