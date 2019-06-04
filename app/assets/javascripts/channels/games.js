jQuery(document).ready(function() {
  var game;
  game = $('#game_channel');
  if ($('#game_channel').length > 0) {
    App.games = App.cable.subscriptions.create({
      channel: "GamesChannel",
      game_id: game.data('game-id')
    }, {
      connected: function() {
        return console.log("conneted");
      },
      disconnected: function() {
        return console.log("disconneted");
      },
      received: function(data) {
        if((data['game_state'] == 'rate') & (location.pathname.split("admin")[1]!="/play" && $("#admin").val() != true)){
          t = setInterval(function(){
            $.ajax({
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              url: '/mobile/user/game/vidoe_uploading',
              success: function(data1){
                if(data1.redirect){
                  clearInterval(t)
                  window.location.replace(data['game_state'])
                }
              }
            })
          }, 1500)
        }else{
          if ($("#game_channel").data("turn") !== "replay") {
            if(location.pathname.split("admin")[1]=="/play"){
              if(typeof completed_ajax !== 'undefined'){
                if (videoStopped != true){
                  stopRecording(data['game_state'], function(x){
                    window.location.replace(x)
                  })
                }
              }else{
                if(typeof redirect == "undefined")
                  return window.location.replace(data['game_state']);
              }
            }else{
              if(typeof redirect == "undefined")
                return window.location.replace(data['game_state']);
            }
          } else {
            console.log("return to replay page");
            if(typeof redirect == "undefined")
              return window.location.replace("replay");
          }
        }
      }
    });
    $(window).bind('beforeunload', function(){
      App.games.unsubscribe()
    });
  }
});

function ajaxCheck(completed_ajax){
  if(completed_ajax == false){
    return ajaxCheck(completed_ajax)
  }else{
    return completed_ajax
  }
}
