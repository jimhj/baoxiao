xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title "#{t('indexs.recent')}_#{Settings.app_title}" 
    xml.link root_url
    xml.description(Settings.app_description)
    xml.language('zh-cn')
      for joke in @jokes
        title = joke.title.blank? ? joke.content.truncate(30) : joke.title
        xml.item do
          xml.title title
          xml.description joke.content
          xml.image do
            if joke.picture.present?
              xml.url joke.picture.normal.url
            end
            xml.title title
            xml.link joke_url joke
          end
          xml.author "www.xiaohuabolan.com"
          xml.pubDate(joke.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link joke_url joke
          xml.guid joke_url joke
        end
      end
  }
}
