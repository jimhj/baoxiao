# Set the host name for URL creation
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.default_host = "http://www.xiaohuabolan.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add recent_jokes_path, :priority => 0.7, :changefreq => 'daily'
  add hot_jokes_path, :priority => 0.7, :changefreq => 'daily'

  add tags_path, :priority => 0.7, :changefreq => 'daily'

  Joke.tag_counts_on(:tags).order('taggings_count DESC').each do |tag|
    add tag_path(tag.name), lastmod: Time.now
  end

  Joke.find_each do |joke|
    add joke_path(joke), lastmod: joke.updated_at
  end
end
