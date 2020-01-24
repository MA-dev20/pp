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
        var game_state = data['desktop'];

        console.log(data)
        // console.log(App.videoInProgress)
        if (App.videoInProgress && location.pathname.split("admin")[0]=="/mobile/" && location.pathname.split("admin")[1]=="/play") {
        } else {
          if ((game_state == "youtube_video") && (window.location.pathname.split("mobile").length == 1)) {
            return window.location.replace('youtube_video');
          } else if((game_state == "youtube_video") && (window.location.pathname.split("admin").length > 1)) {
            return window.location.replace('youtube_video');
          }
          if((data['game_state'] != 'ended_game') && location.pathname.split("user")[0]=="/mobile/" && location.pathname.split("user")[1]=="/game/bestlist"){
            return window.location.replace("replay");
          } else {
          if(data['game_state']){
            if((data['game_state'] == 'rate') && ((location.pathname.split("admin").length > 1) && location.pathname.split("admin")[1]!="/play" && $("#admin").val() != true)){
              ajaxRequestToCheck("rate")
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
        }
        }
      }
    });
    $(window).bind('beforeunload', function(){
      if((location.pathname.split("user")[0]=="/mobile/" && location.pathname.split("user")[1]=="/game/bestlist"){
        console.log('nothing')
      }
      else {
        console.log('unsubscribe')
        App.games.unsubscribe()
      }
    });
  }
});
function ajaxRequestToCheck(state){
    $.ajax({
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      url: '/mobile/user/game/vidoe_uploading',
      success: function(data1){
        if(data1.redirect){
          return window.location.replace("rate")
        }else{
          ajaxRequestToCheck()
        }
      }
    })
   } 

function ajaxCheck(completed_ajax){
  if(completed_ajax == false){
    return ajaxCheck(completed_ajax)
  }else{
    return completed_ajax
  }
}
