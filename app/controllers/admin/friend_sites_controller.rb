class Admin::FriendSitesController < Admin::ApplicationController
  before_action :find_site, only: [:edit, :update, :destroy]

  def index
    @sites = FriendSite.order('priority DESC, id DESC')
  end

  def new
    @site = FriendSite.new(priority: 1000, status: 1)
  end

  def create
    @site = FriendSite.new site_params
    @site.user_id = current_user.id

    if @site.save
      expire_fragment(%r{/*/index})
      expire_fragment(%r{/*/\?page*})      
      redirect_to admin_friend_sites_path
    else
      render :new
    end    
  end

  def edit
  end

  def update
    if @site.update_attributes site_params
      redirect_to admin_friend_sites_path
    else
      render :new
    end    
  end

  def destroy
    @site.destroy
    redirect_to :back
  end

  private

  def find_site
    @site = FriendSite.find params[:id]
  end  

  def site_params
    params.require(:friend_site).permit(:name, :title, :url, :priority, :status)
  end
end