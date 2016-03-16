var map;
function initMap() {
    new google.maps.Map($('#map')[0], {
        center: {lat: -34.397, lng: 150.644},
        zoom: 8
    });
}

$(document).ready(function() {
    map = initMap();
});