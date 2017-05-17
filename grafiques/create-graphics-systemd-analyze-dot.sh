#! /bin/bash
# Nom: Brian Mengibar Garcia
# Curs: hisx2
# Synopsis: Script per crear grafiques de l'us del sistema
#----------------------------------------------------------

OPTION="$1"

# Si l'opció es igual a 0 creara una grafica del target actual
if [ $OPTION -eq 0 ]
then
	systemd-analyze \
	dot --require \
	| dot \
	-Tsvg > graphic-actual.svg

# Si l'opcio es igual a 1 creara una grafica del unit que especifiquem
elif [ $OPTION -eq 1 ]
then
	systemd-analyze \
	dot $2 \
	--require \
	| dot \
	-Tsvg > $2.svg

# Si l'opcio es igual a 2 creara una grafica del unit que especifiquem
# per veure qui depen d'aquest
elif [ $OPTION -eq 2 ]
then
	systemd-analyze \
	dot \
	--from-pattern=$2 \
	--require \
	| dot \
	-Tsvg > from-$2.svg

# Si l'opcio es igual a 3 creara una grafica del unit que especifiquem
# per veure que necessita per engegarse
elif [ $OPTION -eq 3 ]
then
	systemd-analyze \
	dot \
	--to-pattern=$2 \
	--require \
	| dot \
	-Tsvg > to-$2.svg

# Si l'opció conté qualsevol altre numero, creara una grafica dels dos
# units que especifiquem per veure tota la relació que tenen
else
	systemd-analyze \
	dot \
	--from-pattern=$2 \
	--to-pattern=$3 \
	--require \
	| dot \
	-Tsvg > $2-$3.svg
fi

exit 0
