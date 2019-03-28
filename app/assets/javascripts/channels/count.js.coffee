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
        if data['game_state'] == 'wait'
            $('#myModalAction .modal-body').append '<div class="mail-box">
                <div class="mail-box-main">
                    <span><img src= '+ data["user_avatar"] + '/></span>'+ data["user_fname"] + ' ' + data["user_lname"] +'
                </div>
                <div class="mail-btn">
                    <%= link_to "Accept", accept_user_path(user_id: turn.user.id), method: :patch, params: { status: 1 }, class: "btn btn-secondary btn-accept" %>
                    <%= link_to "Reject", reject_user_path(user_id: turn.user.id), method: :patch, params: { status: 2 }, class: "btn btn-primary btn-reject" %>
                </div>
            </div>'
            $('#myModalAction').show()
            $('#count').text(data['counter'])
        else if data['game_state'] == 'rate'
            $('#middle').text(data["counter"])
            