class AdController < ApplicationController
  # layout false
  skip_before_action :verify_authenticity_token

  def handle
    @ads = Ad.where(ad_type: params[:type])
    @json = @ads.collect{ |a| { version: a.version, partial: a.body } }.to_json.html_safe

    respond_to do |format|
      p 123123123
      format.js { render file: "ad/#{params[:type].downcase}.js.erb" }
    end
  end
end