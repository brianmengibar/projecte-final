#! /bin/bash
# Nom: Brian Mengibar Garcia
# Curs: hisx2
# Sinopsys: Script per pasar un file de extensió md a html
#----------------------------------------------------------

pandoc -t dzslides -s presentacio.md -o presentacio.html

sed -i 's/html { background-color: black; }/html { background-color: #000031; }/g' presentacio.html
