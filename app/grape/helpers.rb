module Baoxiao
  module APIHelpers

    def logger
      Baoxiao::API.logger
    end

    def current_user
      @current_user ||= User.where(private_token: params[:token]).first
    end

    def authenticate!
      error!({ "error" => "401 Unauthorized" }, 401) unless current_user
    end      
  end
end