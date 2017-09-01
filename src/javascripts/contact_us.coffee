jQuery ($) ->  
  
  # The form
  $chooseDistrict = $("#choose-district")

  showDistrictContact = (district) ->
        # The form
        $chooseDistrict = $("#choose-district")

        # Hide all contact cards
        $("aside.contact-us.multi-district .vcard").hide()
        $("aside.contact-us.multi-district .no-district-available").remove()

        # Show selected contact card
        $chosen = $("#district-#{district}")
        if($chosen.length)
          $chosen.show()
        else
          $chooseDistrict.after('<div class="no-district-available">Kontaktinformation för valt område saknas.</div>')

        # Set district in select menu
        $selectDistrict.val district

        # Set selected district in cookie
        $.cookie('city-district', district, { expires: 365, path: '/' } )
  
  $(document).on "change", ".multi-district select", (e) ->    
    showDistrictContact $(e.currentTarget).val()

  $("aside.contact-us .write-to-us").click (event) -> 
    event.preventDefault()
    $trigger = $(@)
    $that = $trigger.parent()
    # Clone form template
    $form = $("aside.contact-us.basic > form.write-to-us-form").clone()
    $form.removeAttr("id")

    # Replace the trigger w/ the form
    $trigger.replaceWith($form.show())

    $(document).on "click", ".write-to-us-form input[type=submit]", ->
      $form = $(@).closest("form")
      $form.submit (event) ->
        event.preventDefault()
        $form.find("input[type=submit]").val("Skickar meddelande ...").attr("disabled", "disabled")
        $.ajax
          type: "POST"
          url: $trigger.attr('data-action')
          data: $form.serialize() + "&contactid=#{$trigger.attr('data-contact-id')}"
          success: (data) ->                      
            $form.replaceWith(data)           
            $that.find('form').show()
          error: (x, y, z) ->   
            $form.after('<div class="error">Ett fel inträffade, vänligen försök senare eller skicka ditt meddelande till nedanstående e-postadress.</div>')                                        

    # Scroll to top of form
    $('html, body').animate
      scrollTop: $form.offset().top - 45
    , 100

  # District selector for Contact us
  if $("aside.contact-us.multi-district").length
    $.cookie.json = true

    # Prevent the form for being submited
    $chooseDistrict.submit -> event.preventDefault()

    # Selectbox
    $selectDistrict = $chooseDistrict.find("select")

    # Select district from cookie on load
    storedDistrict = $.cookie('city-district')
    if !!storedDistrict
      showDistrictContact storedDistrict
    else
      $("aside.contact-us.multi-district .vcard").hide()

    # Autocomplete for street addresses
    # Get address suggestions w/ districts from SBK's map service
    $chooseDistrict.find("input").autocomplete
      source: (request, response) ->
        $.ajax
          url: "//kartor.malmo.se/api/v1/district_from_address/"
          dataType: "jsonp"
          data:
            q: request.term
            items: 10
            group_by: "district"
          success: (data) ->
            response $.map data.addresses, (item) ->
              label: item.name
              district: item.towndistrict
      minLength: 2
      select: (event, ui) ->
        showDistrictContact ui.item.district.toLowerCase()
