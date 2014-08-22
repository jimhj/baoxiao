class AuthController < ApplicationController
  before_action :no_login_required

  def weibo_callback
    auth = request.env["omniauth.auth"]
    Rails.logger.info auth
    user = User.find_or_create_by!(weibo_uid: auth.uid.to_s) do |u|
      if u.new_record?
        u.email = "#{SecureRandom.hex(6)}@weibo.random.com"
        u.remote_avatar_url = File.join(auth.info.avatar_url, 'avatar.jpg')
        u.password = SecureRandom.hex(8)
        u.name = auth.info.name
      end
      u.weibo_token = auth.credentials.token
    end

    login_as user
    remember_me
    redirect_back_or_default root_url root_url
  end

  def qq_callback
    auth = request.env["omniauth.auth"]
    Rails.logger.info auth
  end
end