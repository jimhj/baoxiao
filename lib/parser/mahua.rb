module Parser
  class Mahua < Base
    SCRAP_FROM = 'http://www.mahua.com/diggjokes'

    def scrap
      @opts[:page_start].upto(@opts[:page_stop]).each do |page|
        Rails.logger.info('*' * 60)
        Rails.logger.info("开始抓取第 #{page} 页")

        url = Mahua::SCRAP_FROM
        unless page == 1
          url = "#{Mahua::SCRAP_FROM}/index_#{page}.htm" 
        end
          
        Rails.logger.info(url)

        uri = URI url
        parser = Nokogiri::HTML(uri.open({ "User-Agengt" => Parser::USER_AGENT }))

        parser.xpath("//div[@class='mahua']").each do |c|
          title = c.xpath("./h3/a").first.try :content
          content = c.xpath("./div[@class='content']").first.try(:content)
          picture = c.xpath("./div[@class='content']/p/img[1]/@src").first.try(:value)
          down_votes = c.xpath("./div[@class='link']/div[@class='tools']/ul/li[3]/a").first.try :content
          up_votes = c.xpath("./div[@class='link']/div[@class='tools']/ul/li[4]/a").first.try :content

          joke = @user.jokes.build
          joke.anonymous = true
          joke.title = title
          joke.content = content.presence || title
          joke.remote_picture_url = picture if picture
          joke.up_votes_count = up_votes.to_i
          joke.down_votes_count = -(down_votes.to_i)
          joke.from = 'MH'

          unless joke.save
            Rails.logger.info("#{content} 保存失败")
            Rails.logger.info(joke.errors.full_messages)
          end
        end              
      end
    end

  end
end