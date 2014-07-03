jQuery ($) ->
  $("aside.feedback .trigger").click ->
    $(@).hide()
    $("aside.feedback form").slideDown(100)
    $('html, body').animate
      scrollTop: $("aside.feedback").offset().top - 45
    , 100
