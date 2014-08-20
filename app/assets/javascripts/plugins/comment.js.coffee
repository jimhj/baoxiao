baoxiao.Comments =
  updateComment: (id, liked = true) ->
    if liked
      $("#comment-#{id} a.likeComment").addClass('disabled')
  updateComments: (ids, liked = true) ->
    return if $('#commentsWrapper').length == 0
    for id in ids
      @updateComment(id, liked)