class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.order('id DESC').paginate(page: params[:page], per_page: 20)   
  end
end