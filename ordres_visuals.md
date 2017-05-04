### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
------------------------------------------------------

# Ordres visuals
Dins del sistema podem trobar diferents tipus d'ordres visuals, podem
trobar ordres que ens retornen una imatge, ordres que ens retornen una
grafica etc. Aquestes son les que jo he trobat i crec que les millors
que tenim en el sistema:

* ``systemd-analyze plot``
Crea un archiu amb format ``.svg`` que descriu el procés d'arrancada de 
forma gráfica. 

```
[isx39441584@i10 projecte-final]$ systemd-analyze plot > grafica.svg && echo "Si surt aquest missatge? Significa que a anat be"
Si surt aquest missatge? Significa que a anat be
[isx39441584@i10 projecte-final]$ ll | grep grafica.svg
-rw-r--r--. 1 isx39441584 hisx2 116182 Apr 26 12:36 grafica.svg
```

![Grafica-plot](./grafiques/grafica_plot.png)

* ``systemd-analyze dot``
També crea un archiu amb format ``.svg`` que mostra un grafic de l'us
del sistema pero cal dir, que es una mica "lio". Lo primer que cal fer
es instal·lar el paquet **graphviz**. Una vegada instal·lat, ja podem 
executar l'ordre, que com podem veure, el resultat s'emmagatzemara en un
archiu ``.svg`` que en aquest cas s'anomenarà **systemd.svg**.

```
systemd-analyze dot --require | dot -Tsvg > systemd.svg
   Color legend: black     = Requires
                 dark blue = Requisite
                 dark grey = Wants
                 red       = Conflicts
                 green     = After
```

![Grafica-dot-system](./grafiques/grafica_dot.png)

Amb aquesta ordre hem extret una imatge de l'us de **tot** el sistema,
pero també podem crear el grafic a partir d'un punt especific, per exemple
podem dir que comenci el grafic a partir de httpd.service.

```
systemd-analyze dot 'httpd.service' --require | dot -Tsvg > httpd.svg
   Color legend: black     = Requires
                 dark blue = Requisite
                 dark grey = Wants
                 red       = Conflicts
                 green     = After
```

![Grafica-dot-httpd](./grafiques/httpd.png)

> He agafat httpd per que la grafica es molt mes petita, ja que en
la imatge d'abans de tot el sistema no es veu practicament **res**.
