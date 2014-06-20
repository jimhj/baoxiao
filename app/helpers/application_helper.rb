module ApplicationHelper
  MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                        'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                        'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                        'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                        'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
  def mobile?
    agent_str = request.user_agent.to_s.downcase
    return false if agent_str =~ /ipad/
    agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
  end

  def render_page_title
    site_name = Settings.app_name
    title = "#{site_name}_#{Settings.app_title}"
    unless @page_title.blank?
      title = "#{@page_title}_#{title}" 
    end 
    content_tag("title", title, nil, false)
  end  

  def social_share_items(joke)
    share_list = { weibo: '微博', renren: '人人', qq: 'QQ空间' }
    # if mobile?
    #   share_list.merge(weixin: '微信')
    # end

    items = share_list.collect do |k, v|
      case k.to_s
      when 'weibo'
        url = "http://service.weibo.com/share/share.php?url=#{joke_url(joke)}&type=3&pic=#{joke.picture.normal.url}&title=#{joke.content}"
      when 'renren'
        url = "http://widget.renren.com/dialog/share?resourceUrl=#{joke_url(joke)}&srcUrl=#{joke_url(joke)}&title=#{joke.title}&pic=#{joke.picture.normal.url}&description=#{joke.content}"
      when 'qq'
        url = "http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=#{joke_url(joke)}&title=#{joke.content}&pics=#{joke.picture.normal.url}"
      when 'weixin'
        url = "#"
      end

      %Q(
        <li>
          <a target="_blank" href="#{url}">
            <i class="fa fa-#{k.to_s}"></i>
            <span class="ml-5">#{v}</span>
          </a>
        </li>
      )
    end.join

    raw items
  end
end
