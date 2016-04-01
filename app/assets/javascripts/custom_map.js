var myLatLng = {lat: 47.860803, lng: 35.0992256};
var map;
var origin_marker;
var destination_marker;
var distance;

function initMap() {
    var directionsService = new google.maps.DirectionsService;
    var directionsDisplay = new google.maps.DirectionsRenderer;

    var point_to_add;
    var timeZoneA, timeZoneB;


    map = new google.maps.Map($('#map')[0], {
        center: myLatLng,
        zoom: 10
    });

    directionsDisplay.setMap(map);

    var distanceService = new google.maps.DistanceMatrixService();

    $(".point").click(function() {
        if($(this).find("#a").length == 1){
            point_to_add = 'A';
        }else{
            point_to_add = 'B';
        }
    });

    google.maps.event.addListener(map, 'click', function(event) {
        if (point_to_add == 'A') {
            origin_marker = placeMarker(origin_marker, event.latLng, 'A');
            $("#origin").val(event.latLng)
        }else if(point_to_add == 'B'){
            destination_marker = placeMarker(destination_marker, event.latLng, 'B');
            $("#destination").val(event.latLng)
        }
    });

    $('#get_directions').click(function() {
        calculateAndDisplayRoute(directionsService, directionsDisplay);
        calculateDistance(distanceService);
        getTimeZone(origin_marker);
        getTimeZone(destination_marker);

        //$("#time_origin").html(timeZoneA);
        //$("#time_destination").html(timeZoneB);

    });

    //STYLE
    var styles = [
        {
            stylers: [
                { hue: "#00ffe6" },
                { saturation: -20 }
            ]
        },{
            featureType: "road",
            elementType: "geometry",
            stylers: [
                { lightness: 100 },
                { visibility: "simplified" }
            ]
        },{
            featureType: "road",
            elementType: "labels",
            stylers: [
                { visibility: "off" }
            ]
        }
    ];
    map.setOptions({styles: styles});
}

function callback(response, status) {

    if (status == "OK") {
        //console.log(response.destinationAddresses[0]);
        //console.log(response.originAddresses[0]);
        //console.log(response.rows[0].elements[0].distance.text);
        distance = response.rows[0].elements[0].distance.text;
        $('#distance').text('distance: ' + distance);
        $('#distance_container').css('height','auto');
    } else {
        alert("Error: " + status);
    }
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

function calculateAndDisplayRoute(directionsService, directionsDisplay) {
    directionsService.route({
        origin: origin_marker.position,
        destination: destination_marker.position,
        travelMode: google.maps.TravelMode.DRIVING
    }, function(response, status) {
        if (status === google.maps.DirectionsStatus.OK) {
            directionsDisplay.setDirections(response);
            origin_marker.setMap(null);
            destination_marker.setMap(null);
        } else {
            window.alert('Directions request failed due to ' + status);
        }
    });
}

function calculateDistance(service){
    service.getDistanceMatrix(
        {
            origins: [origin_marker.position],
            destinations: [destination_marker.position],
            travelMode: google.maps.TravelMode.DRIVING,
            avoidHighways: false,
            avoidTolls: false
        }, callback);
}

function getTimeZone(marker){
    $.ajax({
        url:"https://maps.googleapis.com/maps/api/timezone/json?location="+marker.getPosition().lat()+","+marker.getPosition().lng()+"&timestamp="+(Math.round((new Date().getTime())/1000)).toString()+"&sensor=false"
    }).done(function(response){
        if(marker.label == 'A'){
            $("#a > .time").html(calcTime(response.dstOffset + response.rawOffset));
        }else{
            $("#b > .time").html(calcTime(response.dstOffset + response.rawOffset));
        }
    });
}

function calcTime(offset) {
    var d = new Date();
    var utc = d.getTime() + (d.getTimezoneOffset() * 60000);var nd = new Date(utc + (1000*offset));
    return nd.toLocaleString();
}

function getCity(latlng) {
    new google.maps.Geocoder().geocode({'latLng' : latlng}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            if (results[1]) {
                var country = null, countryCode = null, city = null, cityAlt = null;
                var c, lc, component;
                for (var r = 0, rl = results.length; r < rl; r += 1) {
                    var result = results[r];

                    if (!city && result.types[0] === 'locality') {
                        for (c = 0, lc = result.address_components.length; c < lc; c += 1) {
                            component = result.address_components[c];

                            if (component.types[0] === 'locality') {
                                city = component.long_name;
                                break;
                            }
                        }
                    }
                    else if (!city && !cityAlt && result.types[0] === 'administrative_area_level_1') {
                        for (c = 0, lc = result.address_components.length; c < lc; c += 1) {
                            component = result.address_components[c];

                            if (component.types[0] === 'administrative_area_level_1') {
                                cityAlt = component.long_name;
                                break;
                            }
                        }
                    } else if (!country && result.types[0] === 'country') {
                        country = result.address_components[0].long_name;
                        countryCode = result.address_components[0].short_name;
                    }

                    if (city && country) {
                        break;
                    }
                }

                console.log("City: " + city + ", City2: " + cityAlt + ", Country: " + country + ", Country Code: " + countryCode);
            }
        }
    });
}