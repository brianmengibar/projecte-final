#! /bin/bash
# Nom: Brian Mengibar Garcia
# Curs: hisx2
# Sinopsys: Script per pasar un file de extensió md a html
#----------------------------------------------------------

pandoc --standalone \
	--to=dzslides \
	--incremental \
	presentacio.md \
	--css=propi_style.css \
	--output=presentacio.html
