#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require jquery.validate
#= require nprogress
#= require baoxiao
#= require_tree ./plugins


$(document).on 'page:fetch', ->
  NProgress.start()
$(document).on 'page:change', ->
  NProgress.done()
$(document).on 'page:restore', ->
  NProgress.remove()

$(document).ready ->
  $('a.voteJoke').not('.disabled').click ->
    if baoxiao.currentUser
      url = $(this).data 'href'
      $.post url, { vote_value : $(this).data('vote_value') }
      $(this).siblings('.voteJoke').addClass 'disabled'
    else
      $('#loginModal').modal()


