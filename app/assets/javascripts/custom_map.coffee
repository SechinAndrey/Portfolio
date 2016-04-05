myLatLng =
  lat: 47.860803
  lng: 35.0992256
map = undefined
origin_marker = undefined
destination_marker = undefined
distance = undefined
point_a_time_text = ''
point_b_time_text = ''
point_a_city_text = 'Click here then map'
point_b_city_text = 'Click here then map'
interval = undefined
a_checked = false

sec = ->
  if origin_marker != undefined and a_checked
    getTimeZone origin_marker
  if destination_marker != undefined and b_checked
    getTimeZone destination_marker
  return

@initMap = ->
  directionsService = new (google.maps.DirectionsService)
  directionsDisplay = new (google.maps.DirectionsRenderer)
  point_to_add = undefined
  #var timeZoneA, timeZoneB;
  map = new (google.maps.Map)($('#map')[0],
    center: myLatLng
    zoom: 10)
  directionsDisplay.setMap map
  distanceService = new (google.maps.DistanceMatrixService)
  $('html').click (event) ->
    if point_to_add == 'A'
      $('#a .time').text point_a_time_text
      $('#a .city').text point_a_city_text
      $('.point').css 'border', 'none'
    else
      $('#b .time').text point_b_time_text
      $('#b .city').text point_b_city_text
      $('.point').css 'border', 'none'
    return
  #$('#menucontainer').click(function(event){
  #    event.stopPropagation();
  #});
  $('.point').click (event) ->
    event.stopPropagation()
    $('.point').css 'border', 'none'
    $(this).css 'border', 'solid 2px white'
    if $(this).find('#a').length == 1
      point_to_add = 'A'
      $(this).find('.time').text ''
      $(this).find('.city').text 'click on the map to choose origin'
      $('#b .time').text point_b_time_text
      $('#b .city').text point_b_city_text
    else
      point_to_add = 'B'
      $(this).find('.time').text ''
      $(this).find('.city').text 'click on the map to choose origin'
      $('#a .time').text point_a_time_text
      $('#a .city').text point_a_city_text
    return
  google.maps.event.addListener map, 'click', (event) ->
    if point_to_add == 'A'
      origin_marker = placeMarker(origin_marker, event.latLng, 'A')
      $('#origin').val event.latLng
      getTimeZone origin_marker
      if destination_marker != undefined
        getTimeZone destination_marker
      #if (interval == undefined){
      #    interval = setInterval("sec()", 1000)
      #}
      getCity origin_marker
      $('#distance_container').css 'height', '0'
    else if point_to_add == 'B'
      destination_marker = placeMarker(destination_marker, event.latLng, 'B')
      $('#destination').val event.latLng
      getTimeZone destination_marker
      if origin_marker != undefined
        getTimeZone origin_marker
      #if (interval == undefined){
      #    interval =setInterval("sec()", 1000)
      #}
      getCity destination_marker
      $('#distance_container').css 'height', '0'
    return
  $('#get_directions').click (event) ->
    calculateAndDisplayRoute directionsService, directionsDisplay
    calculateDistance distanceService
    #$("#time_origin").html(timeZoneA);
    #$("#time_destination").html(timeZoneB);
    return
  #STYLE
  styles = [
    { stylers: [
      { hue: '#00ffe6' }
      { saturation: -20 }
    ] }
    {
      featureType: 'road'
      elementType: 'geometry'
      stylers: [
        { lightness: 100 }
        { visibility: 'simplified' }
      ]
    }
    {
      featureType: 'road'
      elementType: 'labels'
      stylers: [ { visibility: 'off' } ]
    }
  ]
  map.setOptions styles: styles
  return

callback = (response, status) ->
  if status == 'OK'
#console.log(response.destinationAddresses[0]);
#console.log(response.originAddresses[0]);
#console.log(response.rows[0].elements[0].distance.text);
    distance = response.rows[0].elements[0].distance.text
    $('#distance').text 'distance: ' + distance
    $('#distance_container').css 'height', 'auto'
  else
    alert 'Error: ' + status
  return

placeMarker = (marker, location, lable) ->
  `var marker`
  if marker == undefined
  else
    marker.setMap null
  marker = new (google.maps.Marker)(
    position: location
    map: map
    label: lable)
  marker

calculateAndDisplayRoute = (directionsService, directionsDisplay) ->
  directionsService.route {
    origin: origin_marker.position
    destination: destination_marker.position
    travelMode: google.maps.TravelMode.DRIVING
  }, (response, status) ->
    if status == google.maps.DirectionsStatus.OK
      directionsDisplay.setDirections response
      origin_marker.setMap null
      destination_marker.setMap null
    else
      window.alert 'Directions request failed due to ' + status
    return
  return

calculateDistance = (service) ->
  service.getDistanceMatrix {
    origins: [ origin_marker.position ]
    destinations: [ destination_marker.position ]
    travelMode: google.maps.TravelMode.DRIVING
    avoidHighways: false
    avoidTolls: false
  }, callback
  return

getTimeZone = (marker) ->
  $.ajax(url: 'https://maps.googleapis.com/maps/api/timezone/json?location=' + marker.getPosition().lat() + ',' + marker.getPosition().lng() + '&timestamp=' + Math.round((new Date).getTime() / 1000).toString() + '&sensor=false').done (response) ->
    if marker.label == 'A'
      point_a_time_text = calcTime(response.dstOffset + response.rawOffset)
      $('#a > .time').html point_a_time_text
    else
      point_b_time_text = calcTime(response.dstOffset + response.rawOffset)
      $('#b > .time').html point_b_time_text
    return
  return

calcTime = (offset) ->
  d = new Date
  utc = d.getTime() + d.getTimezoneOffset() * 60000
  nd = new Date(utc + 1000 * offset)
  nd.toLocaleString()

getCity = (marker) ->
  latlng = new (google.maps.LatLng)(marker.getPosition().lat(), marker.getPosition().lng())
  (new (google.maps.Geocoder)).geocode { 'latLng': latlng }, (results, status) ->
    if status == google.maps.GeocoderStatus.OK
      if results[1]
        country = null
        countryCode = null
        city = null
        cityAlt = null
        city_str = ''
        c = undefined
        lc = undefined
        component = undefined
        r = 0
        rl = results.length
        while r < rl
          result = results[r]
          if !city and result.types[0] == 'locality'
            c = 0
            lc = result.address_components.length
            while c < lc
              component = result.address_components[c]
              if component.types[0] == 'locality'
                city = component.long_name
                city_str += ' City: ' + city + ';'
                break
              c += 1
          else if !city and !cityAlt and result.types[0] == 'administrative_area_level_1'
            c = 0
            lc = result.address_components.length
            while c < lc
              component = result.address_components[c]
              if component.types[0] == 'administrative_area_level_1'
                cityAlt = component.long_name
                city_str += ' City2: ' + cityAlt + ';'
                break
              c += 1
          else if !country and result.types[0] == 'country'
            country = result.address_components[0].long_name
            countryCode = result.address_components[0].short_name
            city_str += ' Country Code: ' + countryCode + ';'
          if city and country
            break
          r += 1
        if marker.label == 'A'
          point_a_city_text = city_str
          $('#a > .city').html city_str
        else
          point_b_city_text = city_str
          $('#b > .city').html city_str
        console.log 'City: ' + city + ', City2: ' + cityAlt + ', Country: ' + country + ', Country Code: ' + countryCode
    return
  return

b_checked = false