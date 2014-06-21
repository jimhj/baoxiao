module JokesHelper
  include ActsAsTaggableOn::TagsHelper
  
  def sibling_joke_path(joke = nil)
    return if joke.nil?
    joke_path joke
  end

  def render_tag tag
    size = (12..24).to_a.sample
    color = "%06x" % (rand * 0xffffff)
    link_to tag.name, tag_path(tag.name), :class => "tag", :style => "font-size: #{size}px; color: ##{color};"
  end
end