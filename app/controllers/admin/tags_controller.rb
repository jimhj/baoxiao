class Admin::TagsController < Admin::ApplicationController
  require 'will_paginate/array'

  def index
    @tags = Joke.tag_counts_on(:tags).order('taggings_count DESC').paginate(page: params[:page], per_page: 50)
  end

  def edit
    @tag = ActsAsTaggableOn::Tag.find params[:id]
  end

  def update
    @tag = ActsAsTaggableOn::Tag.find params[:id]
    if @tag.update_attributes! tag_params
      redirect_to :back
    else
      render :edit
    end
  end

  def jokes
    @jokes = Joke.includes(:user).tagged_with(params[:id]).order('id DESC').paginate(page: params[:page], per_page: 20)
    render template: 'admin/jokes/index'
  end

  private

  def tag_params
    params.require(:acts_as_taggable_on_tag).permit(:name, :description)
  end
end