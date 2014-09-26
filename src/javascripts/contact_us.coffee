jQuery ($) ->
  $("aside.contact-us .write-to-us").click (event) ->
    event.preventDefault()
    $(@).hide()
    $(@).prev("aside.contact-us form").slideDown(100)
    $('html, body').animate
      scrollTop: $(@).prev("aside.contact-us form").offset().top - 35
    , 100