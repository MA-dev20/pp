let W = 800;
let H = 500;
const conf = document.getElementById("conf");
const context = conf.getContext("2d");
const maxConfettis = 100;
const particles = [];
let stopParticlesCreation = false;
let requestAnimationFrameId;

const possibleColors = [
  "DodgerBlue",
  "OliveDrab",
  "Gold",
  "Pink",
  "SlateBlue",
  "LightBlue",
  "Gold",
  "Violet",
  "PaleGreen",
  "SteelBlue",
  "SandyBrown",
  "Chocolate",
  "Crimson"
];

function randomFromTo(from, to) {
  return Math.floor(Math.random() * (to - from + 1) + from);
}

function confettiParticle() {
  this.x = Math.random() * W; // x
  this.y = Math.random() * H - H; // y
  this.r = randomFromTo(10, 15); // radius
  this.d = Math.random() * maxConfettis + 8;
  this.color =
    possibleColors[Math.floor(Math.random() * possibleColors.length)];
  this.tilt = Math.floor(Math.random() * 15) - 10;
  this.tiltAngleIncremental = Math.random() * 0.07 + 0.05;
  this.tiltAngle = 0;

  this.draw = function() {
    context.beginPath();
    context.lineWidth = this.r / 2;
    context.strokeStyle = this.color;
    context.moveTo(this.x + this.tilt + this.r / 3, this.y);
    context.lineTo(this.x + this.tilt, this.y + this.tilt + this.r / 5);
    return context.stroke();
  };
}

function drawParticles () {
  for (var i = 0; i < maxConfettis; i++) {
    particles[i].draw();
  }
}


function Draw() {
  const results = [];

  context.clearRect(0, 0, W, window.innerHeight);

  drawParticles();
  let particle = {};

  let remainingFlakes = 0;
  for (var i = 0; i < maxConfettis; i++) {
    particle = particles[i];

    particle.tiltAngle += particle.tiltAngleIncremental;
    particle.y += (Math.cos(particle.d) + 3 + particle.r / 2) / 2;
    particle.tilt = Math.sin(particle.tiltAngle - i / 3) * 15;

    if (particle.y <= H) remainingFlakes++;

    // If a confetti has fluttered out of view,
    // bring it back to above the viewport and let if re-fall.
    if (particle.x > W + 20 || particle.x < -20 || particle.y > H) {
      if (!stopParticlesCreation) {
        particle.x = Math.random() * W;
        particle.y = -30;
        particle.tilt = Math.floor(Math.random() * 10) - 20;
      }
    }
  }

  // Magical recursive functional love
  requestAnimationFrameId = requestAnimationFrame(Draw);
}

window.addEventListener(
  "resize",
  function() {
    W = window.innerWidth;
    H = window.innerHeight;
    conf.width = window.innerWidth;
    conf.height = window.innerHeight;
  },
  false
);

// Push new confetti objects to `particles[]`
for (var i = 0; i < maxConfettis; i++) {
  particles.push(new confettiParticle());
}

// Initialize
conf.width = W;
conf.height = H;


function animate(time) {
  Draw();
  setTimeout(function () {
    const requestAnimationFrameIdToStop = requestAnimationFrameId;
    stopParticlesCreation = false;
    setTimeout(function() {
      cancelAnimationFrame(requestAnimationFrameIdToStop);
    }, 20000);
  }, time);
}

animate(2000);
