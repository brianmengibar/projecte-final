### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
------------------------------------------------------

# Eines per analitzar i gestionar Systemd
En l'altre document ja hem parlat sobre systemd i molts dels seus parametres,
si encara no ho habeu llegit, aqui teniu un enllaç per llegir-ho
abans de llegir aquest: [Systemd].

Hi ha moltes eines per poder gestionar i analitzar ``systemd``, en aquest
document explicaré totes les que he trobat, que paso a llistar-les per
despres explicar **exhaustivament** cadascuna:
* ``systemd-analyze``
* ``Systemadm``
* ``Systemd-kcm``
* ``Administrador de servicios`` --> de Yast????

## Systemd-analyze
Permet evaluar el proces d'arrencada amb el fi de mostrar quines unitats
estan ocasionan una demora en el procés en el procés d'arrencada. Aquestes
unitats, fan referencia fundamentalment a:
* serveis (.service)
* punts de montatje (.mount)
* dispositius (.device)
* sockets (.socket)

Una vegada obtinguda tota aquesta informació, es podria optimitzar el sistema
per minimitzar els temps d'arrencada.

### Parametres de Systemd-analyze
A continuació comentaré tots els parametres que te aquesta ordre:

*  systemd-analyze

Que ens mostra una sortida com aquesta
```
systemd-analyze 
       Startup finished in 765ms (kernel) + 1.654s (initrd) + 15.590s (userspace) = 18.010s
```

Aquesta informació general que ens mostra aquesta ordre, es **el temps total
de l'ultima arrencada del sistema**, especificant:
* El temps empleat en carregar el ``kernel``
* La carrega de ``initrd``
* El temps en l'espai de **l'usuari**

Al ser distribució __Fedora__, apareix ``intird``, en cambi en altres distribucions
com **Debian/Ubuntu**, no apareixen i la seva assignació de temps es carrega
en el kernel.

* ``systemd-analyze blame``

Aquest parametre, ens mostra **detalladament**, el temps empleat en carregar
cadascuna de les unitats, per que no quedi molt extens, filtrarem el resultat
d'exexutar aquesta ordre amb un ``head`` per que nomes ens sorti les 10 
primeres lineas. Llavors, en aquest cas que hem posat `head`, ens sortiren
les **10 unitats** que trigan mes en carregar-se.

```
systemd-analyze blame | head
         14.514s plymouth-quit-wait.service
         12.120s mariadb.service
         12.060s postgresql.service
         11.110s accounts-daemon.service
          1.055s plymouth-start.service
           750ms httpd.service
           692ms postfix.service
           578ms lvm2-pvscan@9:0.service
           570ms libvirtd.service
           434ms lvm2-monitor.service
```

* ``systemd-analyze critical-chain``

Aquest parametre es molt util, ja que ens mostra l'informació mes gràfica
a mode d'arbre amb la cadena d'unitats que tenen els majors temps de
carrega a l'hora d'arrencar el sistema

```
systemd-analyze critical-chain 
The time after the unit is active or started is printed after the "@" character.
The time the unit takes to start is printed after the "+" character.

graphical.target @15.576s
└─multi-user.target @15.576s
  └─mariadb.service @936ms +12.120s
    └─network.target @935ms
      └─wpa_supplicant.service @14.619s +12ms
        └─dbus.service @756ms
          └─basic.target @744ms
            └─sockets.target @744ms
              └─iscsiuio.socket @744ms
                └─sysinit.target @736ms
                  └─systemd-update-utmp.service @730ms +5ms
                    └─auditd.service @715ms +14ms
                      └─systemd-tmpfiles-setup.service @692ms +21ms
                        └─fedora-import-state.service @674ms +17ms
                          └─local-fs.target @671ms
                            └─run-user-42.mount @12.137s
                              └─local-fs-pre.target @670ms
                                └─lvm2-monitor.service @236ms +434ms
                                  └─lvm2-lvmetad.service @275ms
                                    └─lvm2-lvmetad.socket @235ms
                                      └─-.mount
                                        └─system.slice
                                          └─-.slice
```

Podem observar que abans de la grafica ens sorten **dos missatges**:
* **The time after the unit is active or started is printed after the "@" character**. Aquesta frase esta mal redactada, llavors no podem saber si es refereix quan esta actiu? O estarted.
* **The time the unit takes to start is printed after the "+" character**. Vol dir que el caracter ``+`` es el temps que tarda en carregar el servei durant l'arrencada.


**SEGUIR CON CRITICAL-CHAIN, SE PUEDE CAMBIAR DE UNIT DESPUES**

``systemd-analyze critical-chain rescue.target``

``systemd-analyze critical-chain emergency.target``

**EXPLICAR TODO ESTO**

[Systemd]:https://github.com/brianmengibar/projecte-final/blob/master/notes_systemd.md

