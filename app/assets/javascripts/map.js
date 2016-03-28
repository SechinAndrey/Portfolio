
var myLatLng = {lat: 47.860803, lng: 35.0992256};

function initMap() {
    map = new google.maps.Map($('#map')[0], {
        center: myLatLng,
        zoom: 10
    });
    marker =  new google.maps.Marker({
        position: myLatLng,
        map: map
    });

    google.maps.event.addListener(map, 'click', function(event) {
        placeMarker(event.latLng);
    });
}


function placeMarker(location) {
    var marker = new google.maps.Marker({
        position: location,
        map: map
    });
}

//OLD CODE

//var map;
//var marker;

//
//function initMap() {
//    return new google.maps.Map($('#map')[0], {
//        center: myLatLng,
//        zoom: 10
//    });
//}
//
//function initMarker(map) {
//    return new google.maps.Marker({
//        position: myLatLng,
//        map: map
//    });
//}
//
//
//$(document).ready(function() {
//    map = new google.maps.Map($('#map')[0], {
//        center: myLatLng,
//        zoom: 10
//    });
//
//    marker =  new google.maps.Marker({
//        position: myLatLng,
//        map: map
//    });
//    //map = initMap();
//    //marker = initMarker(map);
//});

