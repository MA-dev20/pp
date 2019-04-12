jQuery(document).on 'turbolinks:load', ->
  game = $('#count_channel')
  if $('#count_channel').length > 0
    App.games = App.cable.subscriptions.create {
      channel: "CountChannel"
      game_id: game.data('game-id')
    },
    connected: ->
# Called when the subscription is ready for use on the server

    disconnected: ->
# Called when the subscription has been terminated by the server

    received: (data) ->
        if data['count'] == 'true'
            $('#count').text(data["counter"])
            document.getElementById('ping').play()
            if data['modal'] == false
                $("#myModalAction"+data["user_id"]).hide()
        if data['count'] == 'wait-user'
            modal = '<div style="display: none; z-index: 10000;"  class="modal modal-email" id="myModalAction'+data["user_id"]+'" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"><div class="modal-dialog modal-dialog ml-3 modal-dialog-centered mr-3 mr-md-auto" role="document"><div class="modal-content"><div class="modal-header p-2"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div><div class="modal-body"><div class="mail-box d-flex flex-column flex-md-row align-items-md-center"><div class="mail-box-main d-flex flex-column flex-md-row align-items-md-center"><span class="req-img"><img src= '+ data["user_avatar"] + ' /></span><span>'+ data["user_fname"]+data["user_lname"]+'</span></div><div class="mail-btn mt-3 mt-md-0"><a class="btn btn-secondary  btn-accept" data-remote=true rel="nofollow" data-method="patch" href="/game_mobile_user/accept_user/'+data["user_id"]+'">Accept</a><a class="btn btn-primary btn-reject" rel="nofollow" data-remote=true data-method="patch" href="/game_mobile_user/reject_user/'+data["user_id"]+'">Reject</a></div></div></div></div></div></div>'
            $("body").append(modal)
            $('#myModalAction'+data["user_id"]).show()
            runModalJS()
        else if data['game_state'] == 'rate'
            $('#middle').text(data["counter"])
            