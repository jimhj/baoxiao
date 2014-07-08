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
          xml.description do
            content = simple_format(joke.content)
            if joke.picture.present?
              content << raw(%Q(<img src="#{joke.picture.normal.url}"/>))
            end
            xml.cdata!(content)
          end
          xml.author "www.xiaohuabolan.com"
          xml.pubDate(joke.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link joke_url joke
          xml.guid joke_url joke
        end
      end
  }
}
