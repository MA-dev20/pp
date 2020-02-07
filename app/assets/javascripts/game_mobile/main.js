/*
 *= require rails-ujs
 *= require activestorage
 *= require turbolinks
 *= require jquery3
 *= require rangeslider
 *= require game_desktop/progressbar.min
 *= require cable
 *= require social-share-button
 */

function myColor(val) {
    if (val < 0.5 ) {
        return '#'+(Math.round(255-(val*2))).toString(16)+(Math.round(107+(val*288))).toString(16)+(Math.round(108+(val*180))).toString(16);
    } else {
        return '#'+(Math.round(29+((1-val)*450))).toString(16)+(Math.round(218+((1-val)*66))).toString(16)+(Math.round(175+((1-val)*46))).toString(16);
    }
}
function ratecircle(id,text_id,val) {
    var tId = document.getElementById(text_id)
    var bar = new ProgressBar.Circle(id, {
        strokeWidth: 8,
        easing: 'linear',
        duration: 2000,
        color: myColor(val),
        svgStyle: null,
        from: {color: '#ff0000'},
        to: {color: '#00ff00'},
        step: function(state, circle) {
            circle.path.setAttribute('stroke', myColor(circle.value()));
            var value = Math.round(circle.value() * 100);
            tId.innerHTML = value/10.0;
        }
    });
    bar.animate(val);
}
function checkOrientation() {
	if (window.innerHeight > window.innerWidth) {
		$('#content').show();
		$('#landscape').hide();
	} else {
		$('#content').hide();
		$('#landscape').show();
	}
}
