jQuery(document).on 'turbolinks:load', ->
  App.games = App.cable.subscriptions.create {
    channel: "GamesChannel"
  },
    connected: ->
# Called when the subscription is ready for use on the server

    disconnected: ->
# Called when the subscription has been terminated by the server

    received: (data) ->
     # location.replace(data['game_state']);
     if data['game_state'] == 'wait'
       $('#myModalAction .modal-body').append ' <div class="mail-box">
                 <div class="mail-box-main">
                 <span><img src= '+ data["user_avatar"] + '/></span>'+
                 data["user_fname"] + ' ' +
                 data["user_lname"] +
                 '</div>
                 <div class="mail-btn">
                 <a class="btn btn-secondary btn-accept" rel="nofollow" data-method="patch" href="/game_mobile_user/accept_user/'+ data["user_id"]+'">Accept</a>
                 <a class="btn btn-primary btn-reject" rel="nofollow" data-method="patch" href="/game_mobile_user/reject_user/'+ data["user_id"]+'">Reject</a>
                 </div>
                 </div>'
       $('#myModalAction').show()
     else
       $.get('/mobile/user/game/wait/'+data["status"])


