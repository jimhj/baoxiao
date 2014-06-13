module Parser
  class Qiubai < Base
    SCRAP_FROM = 'http://www.qiushibaike.com/late'

    def scrap
      @opts[:page_start].upto(@opts[:page_stop]).each do |page|
        Rails.logger.info('*' * 60)
        Rails.logger.info("开始抓取第 #{page} 页")

        url = "#{Qiubai::SCRAP_FROM}/page/#{page}"
        
        Rails.logger.info(url)

        uri = URI url
        parser = Nokogiri::HTML(uri.open({ "User-Agengt" => Parser::USER_AGENT }))

        parser.xpath("//div[@class='article block untagged mb15']").each do |c|
          content = c.xpath("./div[@class='content']").first.try(:content)
          picture = c.xpath("./div[@class='thumb']//img[1]/@src").first.try(:value)
          up_votes = c.xpath(".//li[@class='up']/a[@class='voting']/span[1]").first.try(:content)
          down_votes = c.xpath(".//li[@class='down']/a[@class='voting']/span[1]").first.try(:content)

          tags = Joke::HOT_WORDS[rand(Joke::HOT_WORDS.length)]

          joke = @user.jokes.build
          joke.anonymous = true
          joke.content = content
          joke.remote_picture_url = picture if picture
          joke.up_votes_count = up_votes.to_i
          joke.down_votes_count = down_votes.to_i.abs
          joke.from = 'QB'

          unless joke.save
            Rails.logger.info("#{content} 保存失败")
            Rails.logger.info(joke.errors.full_messages)
          else
            @user.tag(joke, with: tags, on: :tags)
          end
          
          GC.start
        end             
      end
    end

  end
end