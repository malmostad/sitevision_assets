jQuery ($) ->
  $("aside.contact-us .write-to-us").click (event) ->
    event.preventDefault()
    $(@).hide()
    $("aside.contact-us .write-to-us-form").slideDown(100)
    $('html, body').animate
      scrollTop: $("aside.contact-us form").offset().top - 35
    , 100
