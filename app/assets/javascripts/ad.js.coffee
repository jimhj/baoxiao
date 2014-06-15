baoxiao.AD = 
  init : ->
    $ad = $('.group-ads')
    if $ad.length > 0
      console.log 123123
      @floatingSideBarAd $ad

  floatingSideBarAd : ($ad) ->
    top = $ad.offset().top
    console.log top
    $(window).scroll (e) ->
      y = $(window).scrollTop()
      if y > top - 50 # 50 is the navbar height.
        $ad.addClass 'fixed'
      else
        $ad.removeClass 'fixed'

$(document).ready ->
  baoxiao.AD.init()
