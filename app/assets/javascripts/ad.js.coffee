baoxiao.AD = 
  init : ->
    $ad = $('.group-ads')
    if $ad.length > 0
      @floatingSideBarAd $ad

  floatingSideBarAd : ($ad) ->
    footer_top = $('.footer').offset().top
    ad_h = $ad.height()
    ad_w = $ad.width()
    ad_top = $ad.offset().top

    fixAd = ->
      left_h = if $('body').is('.jokes-show')
        left_h = $('.col-md-8').height() - 20
      else
        $('.jokes').height()
      right_bar_h = $('.col-md-4').height()      
      return if left_h <= right_bar_h

      scrollFunc = ->
        y = $(window).scrollTop()            
        if y > ad_top
          if y + ad_h - 312 + 38 > left_h
            $ad.css({ position: 'absolute', top: left_h - ad_h, width: ad_w })
          else
            $ad.css({ position: 'fixed', top: 0, width: ad_w })
        else
          $ad.css({ position: 'static' })

      if /iPhone|iPad|iPod/i.test(navigator.userAgent)
        document.addEventListener 'touchmove', scrollFunc, false
        document.addEventListener 'scroll', scrollFunc, false
      else
        $(window).scroll (e) ->
          scrollFunc()

    $('.col-md-8').imagesLoaded ->
      fixAd()

$(document).ready ->
  baoxiao.AD.init()
