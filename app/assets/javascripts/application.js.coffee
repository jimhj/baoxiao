#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require jquery.validate
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

