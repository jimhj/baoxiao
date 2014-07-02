class Settings::ApplicationController < ApplicationController
  before_action :login_required, :set_user
  
  private

  def set_user
    @user = current_user
  end  
end