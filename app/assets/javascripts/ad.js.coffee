baoxiao.AD = 
  init : ->
    $ad = $('.group-ads')
    if $ad.length > 0
      @floatingSideBarAd $ad

  floatingSideBarAd : ($ad) ->
    bottom = $('.footer').offset().top
    top = $ad.offset().top
    w = $ad.width()
    $(window).scroll (e) ->
      y = $(window).scrollTop()
      if y > top - 50 # 50 is the navbar height.
        if y + $(window).innerHeight() >= $('body').height()
          h = $('body').height() - $ad.height() - 50
          $ad.removeClass('fixed').css({ position: 'absolute', top: h, width: w })
        else
          $ad.css({ position: 'fixed', top: 48, width: w })
      else
        $ad.css({ position: 'static' })

$(document).ready ->
  baoxiao.AD.init()
