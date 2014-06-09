require 'nokogiri'

module Parser
  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36'

  class Base
    def initialize(opts = {})
      @opts = opts 
      @opts[:page_start] ||= 1
      @opts[:page_stop] ||= 10
      @user = User.first
    end    
  end
end