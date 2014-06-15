# baoxiao.AD = 
#   init : ->

#   loadAds :

#   loadListAds : (version = []) ->
#     for item, i in ads
#       $partial =  $(item['partial'])
#       $partial.addClass "ad-#{item['version']}"
#       $(
#         $('.jokes .list-group-item')[(i + 1) * 5 - 1]
#       ).before $partial

#   loadSideBarAds : (version = []) ->
