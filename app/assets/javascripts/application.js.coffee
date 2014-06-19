#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require jquery.validate
#= require jquery.cookie
#= require jquery.lazyload
#= require nprogress
#= require baoxiao
#= require_tree ./plugins
#= require ad

$(document).on 'page:fetch', ->
  NProgress.start()
$(document).on 'page:change', ->
  NProgress.done()
$(document).on 'page:restore', ->
  NProgress.remove()

$(document).ready ->
  # initial events
  $("img.lazy").lazyload
    effect: "fadeIn"
    threshold: 300

  $('[data-toggle=dropdown]').each ->
    func = -> 
    this.addEventListener('click', func, false)

  $('a.voteJoke').click ->
    return false if $(this).is('.disabled')
    count = parseInt($(this).find('span').text())
    url = $(this).data('href')
    $.post url, { vote_value : $(this).data('vote_value') }
    $(this).parents('ul').find('.voteJoke').addClass('disabled').unbind('click')
    $(this).find('span').text(count + 1)

    if not baoxiao.currentUser
      anonymous_votes = ($.cookie('anonymous_votes') || "").split(',')
      anonymous_votes.push $(this).data('joke_id')
      $.cookie 'anonymous_votes', anonymous_votes
