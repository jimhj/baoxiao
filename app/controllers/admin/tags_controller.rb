class Admin::TagsController < Admin::ApplicationController
  require 'will_paginate/array'

  def index
    # @tags = Joke.tag_counts_on(:tags).order('taggings_count DESC')
    @tags = ActsAsTaggableOn::Tag.order('taggings_count DESC')
  end

  def edit
    @tag = ActsAsTaggableOn::Tag.find params[:id]
  end

  def update
    @tag = ActsAsTaggableOn::Tag.find params[:id]
    tag_params[:keywords] = tag_params[:keywords].to_s.split(/,\s?|，\s?/).join(',')
    if @tag.update_attributes! tag_params
      expire_fragment(%r{/*/tags})
      redirect_to :back
    else
      render :edit
    end
  end

  def search
    @tags = ActsAsTaggableOn::Tag.where("name LIKE '%#{params[:q]}%'").order('taggings_count DESC')
    render template: 'admin/tags/index'
  end

  def jokes
    @jokes = Joke.includes(:user).tagged_with(params[:id]).order('id DESC').paginate(page: params[:page], per_page: 20)
    render template: 'admin/jokes/index'
  end

  private

  def tag_params
    params.require(:acts_as_taggable_on_tag).permit(:name, :description, :seo_title, :keywords)
  end
end