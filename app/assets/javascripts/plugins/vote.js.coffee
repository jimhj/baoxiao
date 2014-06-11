baoxiao.Votes =
  updateVote: (id, voted = true) ->
    if voted
      $("#vote-for-joke-#{id} a.voteJoke").addClass('disabled')
  updateVotes: (ids, voted = true) ->
    for id in ids
      @updateVote(id, voted)