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
        if(val*510 <= 16)
            return '#ff0'+(Math.round(val*510)).toString(16)+'00';
        else {
            return '#ff'+(Math.round(val*510)).toString(16)+'00';
        }
    } else {
        if((1-val)*510 <= 16) {
            return '#0'+(Math.round((1-val)*510)).toString(16)+'ff'+'00';
        }
        else {
            return '#'+(Math.round((1-val)*510)).toString(16)+'ff'+'00';
        }
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