#! /bin/bash
# Nom: Brian Mengibar Garcia
# Curs: hisx2
# Synopsis: Script per crear grafiques que descriu el procés d'arrencada
#-----------------------------------------------------------------------

systemd-analyze \
	plot > grafica-plot-target-actual.svg
