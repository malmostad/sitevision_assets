$ ->
  $("aside.feedback .trigger").click ->
    $(@).hide()
    $("aside.feedback form").slideDown(100)
    $('html, body').animate
      scrollTop: $("aside.feedback").offset().top - 45
    , 100

  $("aside.contact-us .write-to-us").click (event) ->
    event.preventDefault()
    $(@).hide()
    $("aside.contact-us form").slideDown(100)
    $('html, body').animate
      scrollTop: $("aside.contact-us form").offset().top - 35
    , 100
