$(document).ready(function() {
    $('.fullpage').fullpage({
        menu: '.navbar',
        scrollingSpeed: 500,
        verticalCentered: true,
        resize : false,
        anchors:['firstPage', 'secondPage', 'thirdPage'],
        navigation: false,
        navigationPosition: 'right',
        navigationTooltips:['firstPageTooltip', 'secondPageTooltip', 'thirdPageTooltip', 'fourthPageTooltip'],
        css3: true,
    });
});



