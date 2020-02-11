jQuery(document).ready(function() {
	var vertrieb;
	vertrieb = $('#vertrieb_channel');
	if ($('#vertrieb_channel').length > 0) {
		App.vertrieb = App.cable.subscriptions.create({
		   channel: "VertriebChannel",
      	   vertrieb_id: vertrieb.data('vertrieb-id')
    	}, {
          connected: function() {
			  return console.log('connected');
		  },
          disconnected: function() {
			  return console.log('disconnected');
		  },
          received: function(data) {
			  if(data['vertrieb_state']){
				  return window.location.replace(data['vertrieb_state']);
			  }
		  }
		});
		$(window).bind('beforeunload', function(){
      		App.vertrieb.unsubscribe()
    	});
	}
});