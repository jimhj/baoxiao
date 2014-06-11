#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require jquery.validate
#= require nprogress
#= require_tree ./plugins

$(document).on 'page:fetch', ->
  NProgress.start()
$(document).on 'page:change', ->
  NProgress.done()
$(document).on 'page:restore', ->
  NProgress.remove()

