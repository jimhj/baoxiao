class UsersController < ApplicationController  
  before_action :no_login_required, only: [:new, :create]

  def new
    store_location params[:return_to]
    @user = User.new
  end

  def create
    @user = User.new params.require(:user).permit(:email, :name, :password)
    if @user.save
      login_as @user
      redirect_back_or_default root_url
    else
      p @user
      render :new
    end
  end  

  def check_email
    respond_to do |format|
      format.json do
        render json: !User.where('lower(email) = ?', params[:user][:email].downcase).where.not(id: params[:id]).exists?
      end
    end
  end

  def check_name
    respond_to do |format|
      format.json do
        render json: !User.where('lower(name) = ?',  params[:user][:name].downcase).where.not(id: params[:id]).exists?
      end
    end
  end  
end