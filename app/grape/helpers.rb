module Baoxiao
  module APIHelpers

    def logger
      Baoxiao::API.logger
    end

    def current_user
      @current_user ||= User.find_by(private_token: params[:token])
    end

    def authenticate!
      error!({ "error" => "401 Unauthorized" }, 401) unless current_user
    end      
  end
end