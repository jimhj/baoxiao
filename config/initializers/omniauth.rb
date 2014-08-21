Rails.application.config.middleware.use OmniAuth::Builder do
  require 'weibo'
  provider :weibo, Settings.weibo_key, Settings.weibo_secret
end