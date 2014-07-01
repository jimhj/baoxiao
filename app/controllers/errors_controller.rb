class ErrorsController < ApplicationController
  def not_found
    @joke = Joke.random || Joke.order('hot DESC').first
    set_meta_data
    render template: 'jokes/show'    
  end
  
  def set_meta_data
    title = @joke.title.presence || @joke.content
    tag_list = @joke.tags.map(&:name)
    keywords = ([title] + tag_list).join(',')
    description = ([title, @joke.content] + tag_list).join(',')
    set_seo_meta title, keywords, description    
  end  
end