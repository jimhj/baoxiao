baoxiao.AD = 
  init : ->
    $ad = $('.group-ads')
    if $ad.length > 0
      @floatingSideBarAd $ad

  floatingSideBarAd : ($ad) ->
    footer_top = $('.footer').offset().top
    ad_top = $ad.offset().top
    ad_w = $ad.width()

    fixAd = ->
      left_h = $('.col-md-8').outerHeight()
      right_bar_h = $('.col-md-4').outerHeight()      
      return if left_h <= right_bar_h

      $(window).scroll (e) ->
        y = $(window).scrollTop()
        if y > ad_top
          if y + $(window).innerHeight() >= $('body').height()
            h = y - $('.navbar').height() - $('.site-top').height() - 7
            $ad.removeClass('fixed').css({ position: 'absolute', top: h, width: ad_w })
          else
            $ad.css({ position: 'fixed', top: 0, width: ad_w })
        else
          $ad.css({ position: 'static' })

    if $('.jokes-show').length > 0 or $('.jokes-random').length 
      $('.thumb img').load ->
        fixAd()
    else
        fixAd()

$(document).ready ->
  baoxiao.AD.init()
