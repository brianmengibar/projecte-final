#! /bin/bash
# Nom: Brian Mengibar Garcia
# Curs: hisx2
# Synopsys: Script que crea un PDF de la pàgina manual desitjada
#----------------------------------------------------------------
man -t $1 | ps2pdf - "$1.pdf"
exit 0
