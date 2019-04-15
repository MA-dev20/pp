jQuery(document).on 'turbolinks:load', ->
  game = $('#game_channel')
  if $('#game_channel').length > 0
    App.games = App.cable.subscriptions.create {
      channel: "GamesChannel"
      game_id: game.data('game-id')
    },
    connected: ->
# Called when the subscription is ready for use on the server

    disconnected: ->
# Called when the subscription has been terminated by the server

    received: (data) ->
        if($("#game_channel").data("turn") != "new-turn")
            window.location.replace(data['game_state'])


