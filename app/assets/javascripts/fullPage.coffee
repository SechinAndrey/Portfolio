$(document).ready ->
  $('.fullpage').fullpage
    menu: '.navbar'
    scrollingSpeed: 500
    verticalCentered: true
    resize: false
    anchors: [
      'firstPage'
      'secondPage'
      'thirdPage'
    ]
    navigation: false
    navigationPosition: 'right'
    navigationTooltips: [
      'firstPageTooltip'
      'secondPageTooltip'
      'thirdPageTooltip'
      'fourthPageTooltip'
    ]
    css3: true
    normalScrollElements: '#map'
  return
$ ->
  $('#login-form-link').click (e) ->
    $('#login-form').delay(100).fadeIn 100
    $('#register-form').fadeOut 100
    $('#register-form-link').removeClass 'active'
    $(this).addClass 'active'
    e.preventDefault()
    return
  $('#register-form-link').click (e) ->
    $('#register-form').delay(100).fadeIn 100
    $('#login-form').fadeOut 100
    $('#login-form-link').removeClass 'active'
    $(this).addClass 'active'
    e.preventDefault()
    return
  return
