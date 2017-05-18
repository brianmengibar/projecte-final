#! /bin/bash
# Nom: Brian Mengibar Garcia
# Curs: hisx2
# Sinopsys: Script per pasar un file de extensió md a html
#----------------------------------------------------------

pandoc -t dzslides -s presentacio.md -o presentacio.html
