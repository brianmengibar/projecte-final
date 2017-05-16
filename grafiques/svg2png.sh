#! /bin/bash
# Nom: Brian Mengibar Garcia
# Curs: hisx2
# Synopsis: Script que converteix imatges de svg a png
#----------------------------------------------------------------

for i in *.svg
do
	# lamentablement obre un pop-up!!!
	inkscape --export-png=$i ${i%.svg}.png #>/dev/null 2>&1
done

exit 0
