var myLatLng = {lat: 47.860803, lng: 35.0992256};
var map;
var origin_marker;
var destination_marker;


function initMap() {
    map = new google.maps.Map($('#map')[0], {
        center: myLatLng,
        zoom: 10
    });
    //my_marker =  new google.maps.Marker({
    //    position: myLatLng,
    //    map: map
    //});

    google.maps.event.addListener(map, 'click', function(event) {
        if ($("#origin").is(":focus")) {
            origin_marker = placeMarker(origin_marker, event.latLng, 'A');
            console.log(event.latLng)
        }else if($("#destination").is(":focus")){
            destination_marker = placeMarker(destination_marker, event.latLng, 'B');
        }

    });

    var directionsDisplay = new google.maps.DirectionsRenderer({
        map: map
    });
    
}

function placeMarker(marker, location, lable) {

    if (marker == undefined) {
    } else {
        marker.setMap(null);
    }

    var marker = new google.maps.Marker({
        position: location,
        map: map,
        label: lable
    });
    return marker;
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

