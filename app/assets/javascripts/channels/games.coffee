jQuery(document).on 'turbolinks:load', ->
  App.games = App.cable.subscriptions.create {
    channel: "GamesChannel"
  },
    connected: ->
# Called when the subscription is ready for use on the server

    disconnected: ->
# Called when the subscription has been terminated by the server

    received: (data) ->
      location.replace(data['game_state']);
      
      console.log(data['game_state']);
      # url = "https://google.com";
      # popitup = (url) ->
      # newwindow = window.open(url, 'name', 'height=200,width=150')
      a = window.location.href
      url = a.split('/')
      wait = url[4]
      if wait == 'wait'
        $('#myModal').modal 'toggle'