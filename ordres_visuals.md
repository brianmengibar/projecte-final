### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
------------------------------------------------------

# Ordres visuals

Dins del sistema podem trobar diferents tipus d'ordres visuals, podem
trobar ordres que ens retornen una imatge, ordres que ens retornen una
gràfica etc. Aquestes son les que jo he trobat i crec que les millors
que tenim en el sistema:

## Explorant plot

L'ordre `systemd-analyze plot` crea un arxiu amb format `.svg` que descriu el procés d'arrancada de 
forma gràfica 

```
$ systemd-analyze plot > grafica-plot-target-actual.svg

$ inkscape --export-png=grafica-plot-target-actual.png grafica-plot-target-actual.svg
Background RRGGBBAA: ffffff00
Area 0:0:1901:5830 exported to 1901 x 5830 pixels (90 dpi)
Bitmap saved as: grafica-plot-target-actual.png
```

![Grafica-plot](grafiques/grafica-plot-target-actual.png)

Com podem observar, en la segona ordre trobem l'eina `ìnkscape`, es necessària
per convertir de format `.svg` a `.png` ja que al pujar les imatges, m'he
donat compte de que **github** no suporta l'extensió `.svg`. Així que
tenia que buscar alguna manera per poder **transformar** de format i la 
veritat que amb `inkscape` es molt fàcil i eficaç, només cal executar
`dnf -y install inkscape`, en el moment que ho tenim instal·lat amb el 
paràmetre `--export-png=` per especificar amb quin format ho volem exportar i al 
final de la línia posant la imatge? Ja fa la conversió automàticament però
té un inconvenient, que lamentablement obre un pop-up que he explorat
com fer per que no sorti però no hi ha cap ordre.

Aquesta gràfica es de `graphical.target`, ja que es en el target que
estic per defecte, llavors lo que acabo de fer es **reiniciar** la maquina
i entrar en __mode 1__ (`rescue.target`) i aquesta es la seva gràfica
que com podem comprovar, es molt diferent.

![grafica-rescue](grafiques/grafica-rescue.png)

Per ultim, des de **mode 1** he fet un `systemctl isolate emergency.target`
per anar a **mode emergency** i aquesta es la gràfica d'aquest
target.

![grafica-emergency](grafiques/grafica-mode-emergency.png)

### Significat colors

Com podem comprovar en aquesta gràfica, a sota podem veure diferents colors tenim diferents colors que
i al costat un nom, que cadascun vol dir:

* `Activating`

	Mostra el temps exacte que tarda a activar-se els units mentre esta en procés l'arrencada.

* `Active` 

	Ens diu en que moment exacte s'activen els units.

* `Deactivating`

	El temps que tarda en ser desactivar-se un unit per el motiu que sigui (ja sigui per un error, un problema, etc).

* `Setting up security module`

	El temps que tarda Systemd en configurar el modul de seguretat.

* `Loading Unit Files`

	El temps que tarda Systemd en carregar els arxius dels units.

### Diferencies entre les gràfiques emergency i rescue

El unit `emergency.target` proporciona l'entorn més mínim possible, es
a dir, el sistema munta el sistema de fitxers arrel només per a **lectura**,
no intenta muntar altres sistemes d'arxius locals, no activa les interfícies
de xarxa, i només inicia uns serveis **essencials**. Per això en la gràfica
podem observar que fa el pas de desactivar tots els serveis que veu que no
son essencials per l'arrencada del sistema. En cambi, en el unit `rescue.target`,
proporciona un entorn d'usuari únic convenient, el sistema intenta
muntar tots els sistemes de fitxers locals i iniciar alguns serveis
del sistema **importants**, però no activa les interfícies de xarxa.

## Explorant dot

L'ordre `systemd-analyze dot` també crea un arxiu amb format `.svg` 
que mostra un gràfic de l'us del sistema. Lo primer que cal fer es 
instal·lar el paquet **graphviz**. Una vegada instal·lat, ja podem 
executar l'ordre, que com he dit abans, el resultat s'emmagatzemara en un
arxiu `.svg`.

```
$ systemd-analyze dot --require \
  | dot -Tsvg > grafica-dot-target-actual.svg
   Color legend: black     = Requires
                 dark blue = Requisite
                 dark grey = Wants
                 red       = Conflicts
                 green     = After

$ inkscape --export-png=grafica-dot-target-actual.png grafica-dot-target-actual.svg
Background RRGGBBAA: ffffff00
Area 0:0:32236.2:1225 exported to 32236 x 1225 pixels (90 dpi)
Bitmap saved as: grafica-dot-target-actual.png
```

Amb aquesta ordre hem extret una imatge de l'us de **tot** el sistema,
partint del nostre target actual, llavors mostrarà tots els units necessaris
per que s'activi el nostre target i tots els units que s'activaran després
ja sigui per que es requerit, per que es un requisit, per que vol, etc.
També podem crear el gràfic a partir d'un punt especific, per exemple, 
podem dir que comenci el gràfic a partir de httpd.service.

He agafat httpd per que la gràfica es molt mes petita, ja que en
la imatge d'abans de tot el sistema no la he ficat per el motiu de que
no es veu pràcticament **res**.

```
$ systemd-analyze dot 'httpd.service' --require \
  | dot -Tsvg > httpd.svg
         Color legend: black     = Requires
                 dark blue = Requisite
                 dark grey = Wants
                 red       = Conflicts
                 green     = After

$ inkscape --export-png=httpd.png httpd.svg
Background RRGGBBAA: ffffff00
Area 0:0:767.5:235 exported to 768 x 235 pixels (90 dpi)
Bitmap saved as: httpd.png
```

![Grafica-dot-httpd](grafiques/httpd.png)

### Significat dels colors

En el moment que executem aquesta ordre, a sota ens apareix sempre
això:

```
Color legend: black     = Requires
        dark blue = Requisite
        dark grey = Wants
        red       = Conflicts
        green     = After
```

Aquests colors són els que es reflecteixen en les **fletxes de les
gràfiques** que òbviament, cadascuna te un significat:

* black

	On apunti una fletxa de color negra vol dir que es requerit que aquell unit estigui activat.

* dark blue

	On apunti una fletxa de color blau fosc vol dir que es un requisit que aquell unit estigui activat.

* dark grey

	On apunti una fletxa de color gris vol dir que aquell unit que estem mirant? Vol que estigui activat un unit especific

* red

	On apunti una fletxa de color vermell vol dir que no poden estar el unit que estem mirant i el que apunta la fletxa activats, ja que entre ells podrueixen conflicte.

* green

	On apunti una fletxa de color verd vol dir que després s'engegara el unit especific o que en el moment que aquest unit específic estigui activat, després ha d'activar el unit que apunta la fletxa.

### Parametres de systemd-analyze dot

Hi ha moments que no volem veure l'us de tot el sistema, o no volem veure
tot l'us del sistema d'un unit específic com hem fet a dalt amb
`httpd.service`, per això he trobat aquests dos paràmetres que crec que
son molt útils:

* `--from-pattern` 

	Amb aquest paràmetre podem especificar un unit
	i veure qui depèn d'aquest unit especific, com per exemple del target
	`rescue.target`.

	```
	$ systemd-analyze dot --from-pattern='rescue.target' \
	  | dot -Tsvg > from-rescue.svg
	   Color legend: black     = Requires
					 dark blue = Requisite
					 dark grey = Wants
					 red       = Conflicts
					 green     = After

	$ inkscape --export-png=from-rescue.png from-rescue.svg
	Background RRGGBBAA: ffffff00
	Area 0:0:902.5:145 exported to 903 x 145 pixels (90 dpi)
	Bitmap saved as: from-rescue.png
	```

	![from-rescue](grafiques/from-rescue.png)

	Que com podem observar:
	
  * Es **requerit**(per la fletxa negra) que **després**(per la fletxa verda) d'engegar `rescue.target`, estigui activat `sysinit.target` i `rescue.service`.
  * **Vol**(per la fletxa gris) que estigui activat el servei `systemd-update-utmp-runlevel.service`.
  * Si volem engegar a `shutdown.target` ens diu que entrarà en **conflicte**(per la fletxa vermella), lo que vol dir es que no poden estar els dos activats.

* `--to-pattern`
	
	Amb aquest paràmetre, també podem especificar un unit i veure que 
	necessita per poder engegar-se. Per veure la diferencia entre un parametre
	i altre ho he tornat a fer amb `rescue.target`.
	
	```
	$ systemd-analyze dot --to-pattern='rescue.target' \
	| dot -Tsvg > to-rescue.svg
   Color legend: black     = Requires
                 dark blue = Requisite
                 dark grey = Wants
                 red       = Conflicts
                 green     = After
    
    $ inkscape --export-png=to-rescue.png to-rescue.svg
	Background RRGGBBAA: ffffff00
	Area 0:0:760:145 exported to 760 x 145 pixels (90 dpi)
	Bitmap saved as: to-rescue.png
	```

	![to-rescue](grafiques/to-rescue.png)
	
	Que com podem observar
  * Te que estar activat `systemd-update-utmp-runlevel.service` per **després**(fletxa verda) engegar `rescue.target`
  * Si estem en `multi-user.target` o `graphical.target` entrarà en **conflicte**(fletxa vermella) amb `rescue.target`, lo que vol dir que no poden estar els dos activats

Per ultim, poso un ultim cas, ja que com podem comprovar hem vist tots
els colors de les fletxes en imatges excepte un: \"**dark blue**". Així
que per provar-ho, mostro la gràfica de `abrtd.service`.

```
$ systemd-analyze dot abrtd.service --require | dot -Tsvg > abrtd.svg
   Color legend: black     = Requires
                 dark blue = Requisite
                 dark grey = Wants
                 red       = Conflicts
                 green     = After
                 
$ inkscape --export-png=abrtd.png abrtd.svg
	Background RRGGBBAA: ffffff00
	Area 0:0:760:145 exported to 760 x 145 pixels (90 dpi)
	Bitmap saved as: abrtd.png
```

![service-abrtd](grafiques/abrtd.png)

Com podem veure, al no especificar paràmetre: 

* Ens mostra els serveis que son **requerits**(fletxa blau fosc) que s'activin per que es pugui activar `abrtd.service`.
* Ens mostra que **vol** que estigui activat(fletxa gris) el target `multi-user.target`
* Ens mostra que en el moment que s'activat `abrtd.service` es **requerit**(fletxa negra) que s'activi una serie de units.
* Ens mostra que no te que estar activat el target `shutdown.target` ja que entrarien en **conflicte**(fletxa vermella).

#### Diferencia entre els dos parametres

Una vegada he comentat per separat cada paràmetre, dono pas a explicar 
la seva clara diferència que veig que és necessària explicar:

* `--to-pattern`

	Ens mostra els units que depenen avans del unit que nosaltres especifiquem(idem que l'ordre `systemctl list-dependencies --before unit`
	pero en aquest cas els altres units no es despleguen de forma recursiva).

* `--from-pattern`

	Ens mostra els units que depenen del unit que nosaltres hem especificat(idem que l'ordre `systemctl list-dependencies --after unit`
	pero en aquest cas els altres units no es despleguen de forma recursiva).
