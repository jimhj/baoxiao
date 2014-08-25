#= require jquery
#= require jquery_ujs
#= require bootstrap/dropdown
#= require bootstrap/modal
#= require bootstrap/button
#= require bootstrap/alert
#= require jquery.autosize
#= require jquery.validate
#= require jquery.cookie
#= require imagesloaded.pkgd
#= require baoxiao
#= require_tree ./plugins
#= require ad

# $(document).on 'page:fetch', ->
#   NProgress.start()
# $(document).on 'page:change', ->
#   NProgress.done()
# $(document).on 'page:restore', ->
#   NProgress.remove()

$(document).ready ->
  $('[data-behaviors~=autosize]').autosize()

  $('[data-toggle=dropdown]').each ->
    func = -> 
    this.addEventListener('click', func, false)

  # update current user or anonymous vote status
  $.get '/users/fetch_current_user_as_json', (resp) ->
    if resp.user
      voted_ids = resp.user.voted_joke_ids
      liked_ids = resp.user.liked_comment_ids
      if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
        $('.navbar-nav > li.default').after $('.navbar-nav > li.current_user')
      $('.navbar-nav > li.current_user').replaceWith $(resp.nav)

    else
      voted_ids = ($.cookie('anonymous_votes') || "").split(",")
      liked_ids = ($.cookie('anonymous_likes') || "").split(",")
    
    baoxiao.Votes.updateVotes voted_ids
    baoxiao.Comments.updateComments liked_ids
  , 'json'

  $('a.voteJoke').click ->
    return false if $(this).is('.disabled')
    count = parseInt($(this).find('span').text())
    url = $(this).data('href')
    $.post url, { vote_value : $(this).data('vote_value') }, 'json'
    $(this).parents('ul').find('.voteJoke').addClass('disabled').unbind('click')
    $(this).find('span').text(count + 1)

    # if not baoxiao.currentUser
    anonymous_votes = ($.cookie('anonymous_votes') || "").split(',')
    anonymous_votes.push $(this).data('joke_id')
    $.cookie 'anonymous_votes', anonymous_votes, path: '/'

  $('.site-top a.feed').click ->
    $('#qq-feed').modal()

  if not /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
    $(window).scroll ->
      if $(this).scrollTop() > 100
        $('.scrollToTop').fadeIn()
      else
        $('.scrollToTop').fadeOut()

    $('.scrollToTop').click ->
      $('html, body').animate { scrollTop : 0 }, 800
      return false;
