# jQuery ($) ->
# 	$("ul.share .facebook, ul.share .twitter").on('click', (e) ->
# 		e.preventDefault()
# 		console.log this
# 	)
i = document.createElement("input")
i.setAttribute("type", "number")
if(i.type != "text")
	d = document.getElementById("doar_doacao")
	if(d)
		d.setAttribute("type", "number")
		d.setAttribute("min", "10")