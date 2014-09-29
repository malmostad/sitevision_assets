jQuery ($) ->
	$("aside.contact-us .write-to-us").click (event) ->
		event.preventDefault()
		$(@).hide()
		el = $(this)
		while el.prev().length is 1
			el = el.prev()
			if el.hasClass("write-to-us-form")
				el.slideDown 100
				break
		$('html, body').animate  
			scrollTop: el.offset().top - 35
			, 100 	