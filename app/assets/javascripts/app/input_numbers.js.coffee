i = document.createElement("input")
i.setAttribute("type", "number")
if(i.type != "text")
	d = document.getElementsByTagName('input')
	if(d)
		i = 0
		while(i < d.length)
			if d[i].getAttribute("data-input-type") == "number"
				d[i].setAttribute("type", "number")
				if d[i].getAttribute("data-input-number-min")
					d[i].setAttribute("min", d[i].getAttribute("data-input-number-min"))
			i++