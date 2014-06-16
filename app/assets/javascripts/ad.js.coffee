baoxiao.AD = 
  init : ->
    $ad = $('.group-ads')
    if $ad.length > 0
      @floatingSideBarAd $ad

  floatingSideBarAd : ($ad) ->
    top = $ad.offset().top
    w = $ad.width()
    $(window).scroll (e) ->
      y = $(window).scrollTop()
      if y > top - 50 # 50 is the navbar height.
        $ad.addClass('fixed').attr 'style', "width: #{w}px"
      else
        $ad.removeClass('fixed').removeAttr 'style'

$(document).ready ->
  baoxiao.AD.init()
