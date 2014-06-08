require 'nokogiri'

module Parser
  class Qiubai
    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36'
    SCRAP_FROM = 'http://www.qiushibaike.com/hot'

    def initialize(opts = {})
      @opts = opts 
      @opts[:page_start] ||= 1
      @opts[:page_stop] ||= 10
      @user = User.first
    end

    def scrap
      @opts[:page_start].upto(@opts[:page_stop]).each do |page|
        Rails.logger.info('*' * 60)
        Rails.logger.info("开始抓取第 #{page} 页")

        url = "#{SCRAP_FROM}/page/#{@opts[:page_start]}"
        uri = URI url
        parser = Nokogiri::HTML(uri.open({ "User-Agengt" => USER_AGENT }))

        parser.xpath("//div[@class='article block untagged mb15']").each do |c|
          content = c.xpath("./div[@class='content']").first.try(:content)
          picture = c.xpath("./div[@class='thumb']//img[1]/@src").first.try(:value)

          joke = @user.jokes.build
          joke.anonymous = true
          joke.content = content
          joke.remote_picture_url = picture if picture
          unless joke.save
            Rails.logger.info("#{content} 保存失败")
            Rails.logger.info(joke.errors.full_messages)
          end
        end              
      end
    end

  end
end