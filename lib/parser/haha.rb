module Parser
  class Haha < Base
    SCRAP_FROM = 'http://www.haha.mx/good/day'

    def scrap
      @opts[:page_start].upto(@opts[:page_stop]).each do |page|
        Rails.logger.info('*' * 60)
        Rails.logger.info("开始抓取第 #{page} 页")

        # url = Haha::SCRAP_FROM
        # unless page == 1
          url = "#{Haha::SCRAP_FROM}/#{page}" 
        # end
          
        Rails.logger.info(url)

        uri = URI url
        parser = Nokogiri::HTML(uri.open({ "User-Agengt" => Parser::USER_AGENT }))

        # p parser

        parser.xpath("//div[@class='block joke-item']").each do |c|
          # title = c.xpath("./h3/a").first.try :content
          content = c.xpath("./div[@class='clearfix mt-15']//p[@class='text word-wrap']").first.try(:content)
          picture = c.xpath(".//a[@class='thumbnail']//img/@src").first.try(:value)
          picture = (picture || "").gsub 'small', 'middle'

          tags = c.xpath(".//a[@class='btn-topic']").collect do |tag|
            tag.try(:content)
          end

          down_votes = c.xpath(".//a[@class='btn-icon bad']").first.try(:content)
          up_votes = c.xpath(".//a[@class='btn-icon good']").first.try(:content)

          joke = @user.jokes.build
          joke.anonymous = true
          joke.content = content
          joke.remote_picture_url = picture if picture
          joke.up_votes_count = up_votes.to_i
          joke.down_votes_count = down_votes.to_i.abs
          joke.from = 'HH'
          joke.status = Joke.statuses[:approved]
          
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