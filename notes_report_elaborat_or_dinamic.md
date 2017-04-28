### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
------------------------------------------------------

# METER FOTOS? PASO A PASO? SOLO UNA?

# Cockpit

## Que és cockpit?
És un **administrador de servidor** que fa que sigui fàcil d'administrar
els nostres servidors **GNU/Linux** a través d'un _navegador web_.

### Característiques de cockpit
La veritat es que ``cockpit`` ho veig molt util per els que comencen sent 
administradors de sistemes, ja que permet realitzar fàcilment tasques 
senzilles, com:
* Administració d'emmagatzematge
* Inspecció
* Iniciar i  aturar serveis.

També m'he donat compte de que te una molt bona utilitat i es que dins
de la pagina web podem tenir una terminal, cosa que va molt be, ja que si
surgeix algun problema i ho vols veure graficament ja ho tens tot en una
mateixa pagina. I per ultim, tambe he vist que pot ser __multi-server__,
es a dir, que podem supervisar i administrar diversos servidors al mateix
temps.

Pero jo només em centraré en els serveis i veure totes les utilitats que
tenen relació amb aquest tema.

### Com funciona cockpit
Lo primer de tot sera instal·lar el paquet anomenat ``cockpit``.
```
[root@i10 ~]# dnf -y install cockpit
```

Com podem observar, es un servei, aixi que caldrà iniciar aquest **servei**.
```
[root@i10 ~]# systemctl start cockpit
```

Abans de continuar, cal comprobar que s'ha iniciat correctament.

```
[root@i10 ~]# systemctl status cockpit
● cockpit.service - Cockpit Web Service
   Loaded: loaded (/usr/lib/systemd/system/cockpit.service; static; vendor preset: disabled)
   Active: active (running) since Fri 2017-04-28 09:36:22 CEST; 19s ago
     Docs: man:cockpit-ws(8)
  Process: 3604 ExecStartPre=/usr/sbin/remotectl certificate --ensure --user=root --group=cockpit-ws --selinux-type=etc_t (code=exited, status=0/SUCCESS)
 Main PID: 3615 (cockpit-ws)
    Tasks: 2 (limit: 512)
   CGroup: /system.slice/cockpit.service
           └─3615 /usr/libexec/cockpit-ws

Apr 28 09:36:22 i10 systemd[1]: Starting Cockpit Web Service...
Apr 28 09:36:22 i10 remotectl[3604]: Generating temporary certificate using: openssl req -x509 -days 36500 -newkey rsa:2048 -keyout /etc/cockpit/ws-certs.d/0-
Apr 28 09:36:22 i10 systemd[1]: Started Cockpit Web Service.
Apr 28 09:36:22 i10 cockpit-ws[3615]: Using certificate: /etc/cockpit/ws-certs.d/0-self-signed.cert
```

Una vegada hem vist que el servei està arrancat, cal accedir mediant el
**navegador Firefox**, com? Afegint la teva IP i redirigint al port 9090
que per defecte es el que escolta el servei ``cockpit``
```
https://192.168.2.40:9090/
```

Al accedir ens demanarà un usuari i un password, en el meu cas em logeare
amb **root** amb el seu password corresponent.

### Funcionament de cockpit
En el moment que accedim, la primera pagina ens mostra els detalls del
nostre ordinador i grafics que mostren:
* CPU
* Us de memoria
* Disc I/O
* Trafic de xarxa

A l'esquerra tenim una serie de finestres que paso a continuació a explicar:

* **Sistema**: Es la pagina principal, lo que es mostra res mes accedir a la pagina
* **Llistat de tots els serveis**: Aquesta es la part que profundiré, al fer clic a qualsevol servei, ens porta a una pàgina de detallada que mostra un registre del servei i que ens permet:
  * Start/Stop
  * Restart
  * Enable/Disable
  * Reload
* **Containers**: Permet gestionar els nostres _"contenidors"_ de Docker (**cal dir que aquesta no me he mirat res, ja que no faig res amb Docker**), podem:
  * Cercar nous contenidors
  * Afegir o eliminar els recipients
  * Iniciar i aturar ells
* **Logs**: Conté tots els logs del sistema, es a dir, de tots els serveis, ens permet fer clic a qualsevol entrada per obtenir informació més detallada, com la identificació de procés.
* **Storage**: Dóna un aspecte gràfic en el disc que llegeix i escriu, també ens permet veure els registres pertinents. A més, es pot configurar i administrar els dispositius RAID i grups de volums, donar format, partició, i muntar/desmuntar unitats.
* **Networking**: ENs mostra una visió general de trànsit entrant i sortint, juntament amb els registres pertinents i informació d'interfície de xarxa.
* **Tools**: Aquest menu es desplega per oferir dues eines de gestió de servidors i usuaris adicionals:
  * **Accounts**: Permet afegir i administrar usuaris, configurar i canviar les contrasenyes, afegir i administrar les claus SSH públiques per a cada usuari (**Obviament sempre que siguis root**).
  * **Terminal**: Conté un terminal completament funcional, amb l'implementació del tabulador, aixo ens permet realitzar qualsevol tasca que volguem.

Una vegada explicat la primera part, paso a explicar la segona finestra que tenim
anomenada __Dashboard__. En aquesta finestra lo que trobem es una grafica
amb **4 finestretes**, que es per veure els mateixos grafics que ens surten
en la pagina principal.

Bé, com he comentat a dalt, ``cockpit`` es un multi-server, llavors en aquest
apartat podem fer:
* Afegir una nova maquina
* Editar una maquina actual
* Esborrar una maquina actual

#### Afegir una nova maquina
Per afegir una nova maquina veiem el simbol **+** de color blau que
significa: ``Add Server``. En el moment que cliquem ens demana la **IP** o
el **hostname** de la maquina que volem afegir i amb quin color volem
visualitzar-la (molt util per que si posem el mateix nom en dues maquines
i amb el mateix color? Tindriem un gran problema). En el moment que posem
la IP i le donem a ``Add`` ens diu **Unknown Host Key** ens esta dient que
L'autenticitat de la IP no pot ser establerta, que si estem que volem continuar
amb la connexió, obviament li donem a ``connect`` i ja tenim una maquina mes i al 
ser root, podrem modificar/visualitzar, etc.

### Editar una maquina actual
Per editar una maquina actual veiem el simbol del ``tick``, quan li donem
ens apareixen dos simbols:
 * **Un llapis**: Si li donem al llapis ens deixara modificar:
   * Host Name
   * Color
   * Avatar
 * **Una paperera**: En el moment que cliquem no ens diu si estem segurs, si no que directament l'esborra.

Que passa? Que ara si volem tornar a afegir la maquina anterior ja no ens
dirà **Unknown Host Key**, ja que ja coneix aquest finger print i sap que
si que permetem la connexió.

**PROFUNDIZAR TODO EL TEMA DE SERVICES**
