Rails.application.config.middleware.use OmniAuth::Builder do
  require 'weibo'
  require 'qq'
  provider :weibo, Settings.weibo_key, Settings.weibo_secret
  provider :qq, Settings.qq_key, Settings.qq_secret
end