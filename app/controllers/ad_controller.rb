class AdController < ApplicationController
  # layout false
  skip_before_action :verify_authenticity_token

  def recommends
    position = params[:position].presence || 'bottom'
    @ad_width = params[:width].presence || '624'
    @ad_height = params[:height].presence || '250'
    gap = params[:gap].presence || '14'
    number = params[:number].presence || 8
    @tag_id = params[:t]
    @request_url = ad_pics_url(position: position, number: number, gap: gap, host: 'www.xiaohuabolan.com')

    respond_to do |format|
      format.js { render file: "ad/recommends.js.erb" }
    end
  end

  def pics
    number = params[:number].presence || 8
    number = number.to_i
    @gap = params[:gap]
    @recommends = Joke.recommends(number)
    if params[:position] == 'bottom'
      headers['X-Frame-Options'] = "ALLOWALL"
      render template: 'ad/ad_1', layout: false
    else
    end
  end
end