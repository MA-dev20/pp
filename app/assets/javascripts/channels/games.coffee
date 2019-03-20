jQuery(document).on 'turbolinks:load', ->
  games = $('#game_channel')
  if $('#game_channel').length > 0
    App.games = App.cable.subscriptions.create {
        channel: "GamesChannel"
        game_id: games.data('game-id')
    },
    connected: ->
      log("connected");
    disconnected: ->
      log('disconected');
    received: (data) ->
      location.replace(data['game_state']);