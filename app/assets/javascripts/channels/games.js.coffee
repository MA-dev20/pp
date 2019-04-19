jQuery(document).ready ->
  game = $('#game_channel')
  if $('#game_channel').length > 0
    App.games = App.cable.subscriptions.create {
      channel: "GamesChannel"
      game_id: game.data('game-id')
    },
    connected: ->
        console.log("conneted")
# Called when the subscription is ready for use on the server

    disconnected: ->
        console.log("conneted")
    
# Called when the subscription has been terminated by the server

    received: (data) ->
        if($("#game_channel").data("turn") != "replay")
            window.location.replace(data['game_state'])
        else
            console.log("return to replay page")
            window.location.replace("replay")



