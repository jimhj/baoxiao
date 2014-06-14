class Admin::AdsController < Admin::ApplicationController
  before_action :find_ad, only: [:edit, :update, :destroy]

  def index
    @ads = Ad.order('id DESC').paginate(page: params[:page], per_page: 20)   
  end

  def new
    @ad = Ad.new
  end

  def create
    @ad = Ad.new ad_params
    if @ad.save
      redirect_to admin_ads_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @ad.update_attributes ad_params
      redirect_to admin_ads_path
    else
      render :new
    end
  end

  def destroy
    @ad.destroy
    redirect_to :back
  end

  private

  def find_ad
    @ad = Ad.find params[:id]
  end

  def ad_params
    params.require(:ad).permit(:name, :body, :active)
  end
end