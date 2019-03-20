$(window).scroll(function() {
    /* affix after scrolling 100px */
    if ($(document).scrollTop() > 50) {
        $('header').addClass('affix');
    } else {
        $('header').removeClass('affix');
    }
});