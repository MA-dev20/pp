/*
 *= require jquery3
 *= require game_desktop/typed.min
 *= require game_desktop/progressbar.min
 */
// Pick Sound
function pick(xnum) {
        var number = (Math.floor(Math.random() * xnum) + 1);
        document.getElementById('tag' + number).load();
        document.getElementById('tag' + number).play();
}

// Text Effect on gdesktop Turn
/* Text Animation */
function textanim() {
const resolver = {
  resolve: function resolve(options, callback) {
    // The string to resolve
    const resolveString = options.resolveString || options.element.getAttribute('data-target-resolver');
    const combinedOptions = Object.assign({}, options, {resolveString: resolveString});
    
    function getRandomInteger(min, max) {
      return Math.floor(Math.random() * (max - min + 1)) + min;
    };
    
    function randomCharacter(characters) {
      return characters[getRandomInteger(0, characters.length - 1)];
    };
    
    function doRandomiserEffect(options, callback) {
      const characters = options.characters;
      const timeout = options.timeout;
      const element = options.element;
      const partialString = options.partialString;

      let iterations = options.iterations;

      setTimeout(() => {
        if (iterations >= 0) {
          const nextOptions = Object.assign({}, options, {iterations: iterations - 1});

          // Ensures partialString without the random character as the final state.
          if (iterations === 0) {
            element.textContent = partialString;
          } else {
            // Replaces the last character of partialString with a random character
            element.textContent = partialString.substring(0, partialString.length - 1) + randomCharacter(characters);
          }

          doRandomiserEffect(nextOptions, callback)
        } else if (typeof callback === "function") {
          callback(); 
        }
      }, options.timeout);
    };
    
    function doResolverEffect(options, callback) {
      const resolveString = options.resolveString;
      const characters = options.characters;
      const offset = options.offset;
      const partialString = resolveString.substring(0, offset);
      const combinedOptions = Object.assign({}, options, {partialString: partialString});

      doRandomiserEffect(combinedOptions, () => {
        const nextOptions = Object.assign({}, options, {offset: offset + 1});

        if (offset <= resolveString.length) {
          doResolverEffect(nextOptions, callback);
        } else if (typeof callback === "function") {
          callback();
        }
      });
    };

    doResolverEffect(combinedOptions, callback);
  } 
};

/* Some GLaDOS quotes from Portal 2 chapter 9: The Part Where He Kills You
 * Source: http://theportalwiki.com/wiki/GLaDOS_voice_lines#Chapter_9:_The_Part_Where_He_Kills_You
 */
const strings = [
    document.getElementById('word').innerHTML
];

let counter = 0;

const options = {
  // Initial position
  offset: 0,
  // Timeout between each random character
  timeout: 15,
  // Number of random characters to show
  iterations: 10,
  // Random characters to pick from
  characters: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'x', 'y', 'x', '#', '%', '&', '-', '+', '_', '?', '/', '\\', '='],
  // String to resolve
  resolveString: strings[counter],
  // The element
  element: document.querySelector('[data-target-resolver]')
}

resolver.resolve(options, callback);
}
/* END */
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
/* Animated Circle on game_desktop/rated */
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
function ratecircleg(id,text_id,val) {
    var tId = document.getElementById(text_id)
    var bar = new ProgressBar.Circle(id, {
        strokeWidth: 8,
        easing: 'linear',
        duration: 5000,
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
/* END */