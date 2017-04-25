**Nom: Brian Mengibar Garcia**

**Identificador: isx39441584**

**Curs: HISX2**

**Projecte: _Serveis informatius de Systemd_**
------------------------------------------------------

# Systemd

**Lo primer de tot es sapiguer, que es _systemd_:**

És un gestor del sistema i dels serveis per a Linux, compatible amb els 
``initscript SysV i LSB``. Systemd proporciona una notable capacitat de 
paral·lelització, utilitza l'activació de socket i D-Bus per iniciar 
els serveis, permet l'inici dels dimonis sota demanda, realitza un 
seguiment dels processos amb l'ús dels grups de control de Linux, dóna 
suport _snapshotting_ i la restauració de l'estat del sistema, manté els 
punts muntatge i serveis de muntatge automàtic e implementa un elaborat 
sistema de gestió de dependències basat en un control lògic dels serveis.

**Us basic de systemd**

La principal ordre per controlar _systemd_ es ``systemctl``. Quina utilitat
te? **Controlar el sistema i gestor de serveis systemd**. Per mes informació
sobre l'ordre ``systemctl`` podem consultar  des de la nostra consola
``man 1 systemctl``. Cal mencionar que en el moment que volem engegar, aturar,
veure l'estat, etc d'un servei, sempre caldra ser **#root**.

**Analitzar l'estat del sistema**

A continuació comentare una serie de ordres de la familia systemd:

* ``systemctl list-units``
Amb aquesta ordre podem llistar les unitats que tenim en execució


* ``systemctl list-units -t target``
Aixi podem veure tots els targets(nivells d'execució disponibles en
el sistema


* ``systemctl isolate``
Amb isolate podem pasar de un runlevel a un altre


* ``systemctl list-units-files``
Les unitats disponibles es troben llistades en els directoris **/lib/systemd/system**
i en **/etc/systemd/system**. Pero amb aquesta ordre tambe es poden llistar.
Que ens dona aixo? La llista de les unitats disponibles i l'estatus de cadascuna.


* ``systemctl start``
Ens permet poder engegar un servei


* ``systemctl stop``
Ens permet poder aturar un servei


* ``systemctl restart``
Ens permet poder reiniciar un servei


* ``systemctl status``
Ens mostra l'estat del servei, inclos si esta en execució o no. A part
de tambe mostrar-nos un petit log com el que fa ``journalctl`` pero
molt mes breu, encara que a vegades que no sabem per que no s'engega
el servei ens es molt util.

* ``systemctl enable``
Ens habilita el servei per que a partir d'ara, en el moment que s'arranqui
el sistema, aquest servei ja s'inici automaticament.


* ``systemctl disable``
Ens deshabilita el servei per que a partir d'ara, en el moment que s'arranqui
el sistema, aquest servei no s'inici automaticament.


* ``systemctl is-enabled``
Molt util per comprobar si un servei especific ja esta habilitat o no.

* ``systemctl help``
Et mostra la pagina del manual asociada al servei especific que nosaltres
posem.

* ``systemctl daemon-reload``
Recarga systemd, escanejant en busca de serveis nous o modificats.
