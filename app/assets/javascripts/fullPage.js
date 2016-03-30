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
        normalScrollElements: '#map'
    });
});

$(function() {
    $('#login-form-link').click(function(e) {
        $("#login-form").delay(100).fadeIn(100);
        $("#register-form").fadeOut(100);
        $('#register-form-link').removeClass('active');
        $(this).addClass('active');
        e.preventDefault();
    });
    $('#register-form-link').click(function(e) {
        $("#register-form").delay(100).fadeIn(100);
        $("#login-form").fadeOut(100);
        $('#login-form-link').removeClass('active');
        $(this).addClass('active');
        e.preventDefault();
    });

});

