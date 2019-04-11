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
        if data['count'] == 'wait-user'
            $('.mail-box-main').html('<span><img src= '+ data["user_avatar"] + ' /></span>'+ data["user_fname"] + ' ' + data["user_lname"])
            $('.mail-btn').html('<a class="btn btn-secondary  btn-accept" data-remote=true rel="nofollow" data-method="patch" href="/game_mobile_user/accept_user/'+ data["user_id"]+'">Accept</a>
            <a class="btn btn-primary btn-reject" rel="nofollow" data-remote=true data-method="patch" href="/game_mobile_user/reject_user/'+ data["user_id"]+'">Reject</a>')
            $('#myModalAction').show()
            runModalJS()
        else if data['game_state'] == 'rate'
            $('#middle').text(data["counter"])
            