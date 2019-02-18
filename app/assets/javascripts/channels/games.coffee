jQuery(document).on 'turbolinks:load', ->
  App.games = App.cable.subscriptions.create {
    channel: "GamesChannel"
  },
    connected: ->
      alert("connected");
# Called when the subscription is ready for use on the server

    disconnected: ->
# Called when the subscription has been terminated by the server

    received: (data) ->
#      data['game_state']
#      location.reload(data['url']);
      alert("data received");

