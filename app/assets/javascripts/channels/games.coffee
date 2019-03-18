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
      
      # console.log(data['game_state']);
      # url = "https://google.com";
      # popitup = (url) ->
      # newwindow = window.open(url, 'name', 'height=200,width=150')
      # a = window.location.href
      # url = a.split('/')
      # wait = url[4]
      # if wait == 'wait'
      $('#myModal .mail-body').append('<div class="mail-box">
        <p class="email-add"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">user.email</font></font></p>
        
        <div class="mail-btn">
        <a params="{:status=>1}" class="btn btn-secondary btn-accept" rel="nofollow" data-method="patch" href="/game_mobile_user/accept_user/user.id"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">Accept </font></font></a>
        <a params="{:status=>2}" class="btn btn-primary btn-reject" rel="nofollow" data-method="patch" href="/game_mobile_user/reject_user/user.id"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">Reject</font></font></a>

          <!--- <button type="button" class="btn btn-secondary btn-accept">Accept</button>
            <button type="button" class="btn btn-primary btn-reject">Reject</button>-->
        </div>
        </div>')
      $('#myModal').modal 'toggle'