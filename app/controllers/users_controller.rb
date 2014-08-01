class UsersController < ApplicationController  
  before_action :no_login_required, only: [:new, :create]

  def new
    store_location params[:return_to]
    @user = User.new

    set_seo_meta "#{t('indexs.register')}_#{Settings.app_title}"
  end

  def create
    @user = User.new params.require(:user).permit(:email, :name, :password)
    if @user.save
      login_as @user
      redirect_back_or_default root_url
    else
      render :new
    end
  end

  def show
    @user = User.find params[:id]
    @jokes = @user.jokes
    @jokes = @jokes.where(anonymous: false) unless @user == current_user
    @jokes = @jokes.order('id DESC').paginate(page: params[:page])

    set_seo_meta "#{t('users.title', name: @user.name)}_#{Settings.app_title}"   
  end

  def voted_ids
    render json: (login? ? current_user.voted_joke_ids : nil)
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