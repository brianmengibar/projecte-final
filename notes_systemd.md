### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
------------------------------------------------------

# Que és Systemd?
És un gestor del sistema i dels serveis per a Linux, compatible amb els 
``initscript SysV i LSB``. Systemd proporciona una notable capacitat de 
paral·lelització, utilitza l'activació de socket i D-Bus per iniciar 
els serveis, permet l'inici dels daemons sota demanda, realitza un 
seguiment dels processos amb l'ús dels grups de control de Linux, dóna 
suport _snapshotting_ i la restauració de l'estat del sistema, manté els 
punts muntatge i serveis de muntatge automàtic e implementa un elaborat 
sistema de gestió de dependències basat en un control lògic dels serveis.

## Us basic de systemd
La principal ordre per controlar _systemd_ es ``systemctl``. Quina utilitat
te? **Controlar el sistema i gestor de serveis systemd**. Per mes informació
sobre l'ordre ``systemctl`` podem consultar  des de la nostra consola
``man 1 systemctl``. Cal mencionar que en el moment que volem engegar, aturar,
veure l'estat, etc d'un servei, sempre caldra ser **#root**.

## Analitzar l'estat del sistema
A continuació comentare una serie d'ordres de la familia systemd:

* ``systemctl list-units``
Amb aquesta ordre podem llistar les unitats que tenim en execució.
```
 systemctl list-units
UNIT                                                                                                       LOAD   ACTIVE SUB       DESCRIPTION
proc-sys-fs-binfmt_misc.automount                                                                          loaded active waiting   Arbitrary Executable File Formats File System Automount Point
sys-devices-pci0000:00-0000:00:02.0-backlight-acpi_video0.device                                           loaded active plugged   /sys/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0
sys-devices-pci0000:00-0000:00:02.0-drm-card0-card0\x2dLVDS\x2d1-intel_backlight.device                    loaded active plugged   /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight
sys-devices-pci0000:00-0000:00:1b.0-sound-card0.device                                                     loaded active plugged   82801I (ICH9 Family) HD Audio Controller
sys-devices-pci0000:00-0000:00:1c.0-0000:02:00.0-net-wlo1.device                                           loaded active plugged   RTL8191SEvA Wireless LAN Controller
sys-devices-pci0000:00-0000:00:1c.1-0000:03:00.0-net-enp3s0.device                                         loaded active plugged   RTL8101/2/6E PCI Express Fast/Gigabit Ethernet controller
```

* ``systemctl list-units -t``
Amb el parametre ``-t``, podem veure per exemple tots els targets del 
sistema **ACTIUS**

```
systemctl list-units -t target 
UNIT                   LOAD   ACTIVE SUB    DESCRIPTION
basic.target           loaded active active Basic System
cryptsetup.target      loaded active active Encrypted Volumes
getty.target           loaded active active Login Prompts
graphical.target       loaded active active Graphical Interface
local-fs-pre.target    loaded active active Local File Systems (Pre)
local-fs.target        loaded active active Local File Systems
multi-user.target      loaded active active Multi-User System
network.target         loaded active active Network
nfs-client.target      loaded active active NFS client services
nss-user-lookup.target loaded active active User and Group Name Lookups
paths.target           loaded active active Paths
remote-fs-pre.target   loaded active active Remote File Systems (Pre)
remote-fs.target       loaded active active Remote File Systems
slices.target          loaded active active Slices
sockets.target         loaded active active Sockets
sound.target           loaded active active Sound Card
swap.target            loaded active active Swap
sysinit.target         loaded active active System Initialization
timers.target          loaded active active Timers

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.
```

Per poder veure tots els targets del sistema, ja estiguin actius o inactius
seria:
```
systemctl list-units -t target --all 
  UNIT                   LOAD      ACTIVE   SUB    DESCRIPTION
  basic.target           loaded    active   active Basic System
  cryptsetup.target      loaded    active   active Encrypted Volumes
● dirsrv.target          not-found inactive dead   dirsrv.target
  emergency.target       loaded    inactive dead   Emergency Mode
  getty.target           loaded    active   active Login Prompts
  graphical.target       loaded    active   active Graphical Interface
  local-fs-pre.target    loaded    active   active Local File Systems (Pre)
  local-fs.target        loaded    active   active Local File Systems
  multi-user.target      loaded    active   active Multi-User System
  network-online.target  loaded    inactive dead   Network is Online
```

> Cal mencionar que no només podem veure amb -t els targets, si no que
podem veure tots els units que son:
* automount
* busname
* device
* mount
* path
* scope
* service
* slice
* socket
* swap
* timer

* ``systemctl isolate``
Opció molt util, ja que amb ``isolate`` podem pasar d'un runlevel a un 
altre.
```
systemctl isolate 
ctrl-alt-del.target         halt.target                 multi-user.target           runlevel1.target            runlevel6.target
default.target              initrd-switch-root.service  poweroff.target             runlevel2.target            system-update.target
emergency.target            initrd-switch-root.target   reboot.target               runlevel3.target            
exit.target                 initrd.target               rescue.target               runlevel4.target            
graphical.target            kexec.target                runlevel0.target            runlevel5.target    
```

Al donar-li al tabulador veiem tots els targets en els qual podem accedir(cal dir
que la explicació dels runlevels i targets ho tenim en l'altre document
on seguim parlant sobre [systemd]).

* ``systemctl get-default``
Gràcies a aquesta opció, podem sapiguer en quin target estem actualment
en aquest sistema, per cambiar de target, ho fariem amb l'opció ``ìsolate``
que he comentat abans.

```systemctl get-default 
	graphical.target
```

* ``systemctl set-default``
A vegades es pot donar el cas de que estem en un target en concret pero
que d'aqui dues hores volem estar per exemple en mode __rescue__, doncs be,
en comptes de fer ``systemctl isolate rescue.target``, podem fer
``systemctl set-default rescue.target``, aixó que fa? Doncs que ara per
defecte s'iniciara en mode __rescue__, ja que a esborrar l'antic
``symbolic link`` que apuntaba a __graphical.target__ i a creat un nou
``symbolic link`` que apunta a __rescue.target__.
```
systemctl set-default rescue.target 
Removed symlink /etc/systemd/system/default.target.
Created symlink from /etc/systemd/system/default.target to /usr/lib/systemd/system/rescue.target.
```

I llavors comprovem:
```
systemctl get-default 
	rescue.target
```

Ara si fessim un reboot, automaticament entrariem en mode __rescue__.

* ``systemctl list-unit-files``
Les unitats disponibles es troben llistades en els directoris **/lib/systemd/system**
i en **/etc/systemd/system**. Pero amb aquesta opció, tambe es poden llistar.
Que ens dona aixo? La llista de les unitats disponibles i l'estatus de cadascuna.
```
systemctl list-unit-files
UNIT FILE                                   STATE   
proc-sys-fs-binfmt_misc.automount           static  
org.freedesktop.hostname1.busname           static  
cups.path                                   enabled 
systemd-ask-password-console.path           static  
systemd-ask-password-plymouth.path          static  
systemd-ask-password-wall.path              static  
abrt-ccpp.service                           enabled 
abrt-journal-core.service                   disabled
abrt-oops.service                           enabled 
abrt-pstoreoops.service                     disabled
abrt-vmcore.service                         enabled 
abrt-xorg.service                           enabled 
```

* ``systemctl start``
Ens permet poder engegar un servei.
```
systemctl start sshd
```

* ``systemctl stop``
Ens permet poder aturar un servei.
```
systemctl stop sshd
```

* ``systemctl restart``
Ens permet poder reiniciar un servei.
```
systemctl restart httpd
```

* ``systemctl try-restart``
Similar a ``systemctl restart`` pero aquesta renicia el servei si s'esta
executant, es a dir, si el servei esta aturat? Aquesta ordre no farà 
**res**.
```
systemctl try-restart sshd
```

* ``systemctl reboot``
Ens permet reiniciar el sistema
```
systemctl reboot
```

* ``systemctl poweroff``
Ens permet apagar el sistema
```
systemctl poweroff
```

* ``systemctl halt``
Ens permet tancar **tot** i apagar el sistema
```
systemctl halt
```

* ``systemctl status``
Ens mostra l'estat del servei, inclós si esta en execució o no. A part
de tambe mostrar-nos un petit log com el que fa ``journalctl`` pero
molt mes breu, encara que a vegades quan no sabem per que no s'engega
el servei ens pot ser util.
```
systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: active (running) since lun 2017-05-01 13:26:52 CEST; 19s ago
 Main PID: 3355 (httpd)
   Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Bytes served/sec:   0 B/sec"
    Tasks: 33 (limit: 512)
   CGroup: /system.slice/httpd.service
           ├─3355 /usr/sbin/httpd -DFOREGROUND
           ├─3356 /usr/sbin/httpd -DFOREGROUND
           ├─3357 /usr/sbin/httpd -DFOREGROUND
           ├─3358 /usr/sbin/httpd -DFOREGROUND
           ├─3359 /usr/sbin/httpd -DFOREGROUND
           ├─3361 /usr/sbin/httpd -DFOREGROUND
           └─3362 /usr/sbin/httpd -DFOREGROUND
```

* ``systemctl enable``
Ens habilita el servei per que a partir d'ara, en el moment que s'arranqui
el sistema, aquest servei ja s'inici automaticament.
```
systemctl enable sshd
Created symlink from /etc/systemd/system/multi-user.target.wants/sshd.service to /usr/lib/systemd/system/sshd.service.
```
En el moment que fem enable, es crea un ``symbolic link``, per que aixi
el sistema sapiga que en el moment que s'arranqui el sistema, calgui engegar
aquest servei.

* ``systemctl disable``
Ens deshabilita el servei per que a partir d'ara, en el moment que s'arranqui
el sistema, aquest servei no s'inici automaticament, aixi que s'esborra el
``symbolic link``.
```
systemctl disable sshd
Removed symlink /etc/systemd/system/multi-user.target.wants/sshd.service.
```

* ``systemctl is-enabled``
Molt util per comprobar si un servei especific ja esta habilitat o no.
```
systemctl is-enabled sshd
disabled

systemctl is-enabled httpd
enabled
```

* ``systemctl is-active``
Aquesta opció ens diu si un servei esta engegat o no.
```
systemctl is-active dovecot
inactive

systemctl is-active httpd
active
```

* ``systemctl -t service -a``
S'utilitza per llistar tots els serveis que tenim en el sistema, gracies
al parametre ``-a``, es mostren tots els serveis, ja estiguin actius o
inactius, si treiesim el parametre ``-a``, nomes es veurien els serveis
que estan actius. **EDITAR, MIRAR QUE -t PUEDE TENER MAS, NO SOLO SERVICE**

```
systemctl -t service -a
  UNIT                                                LOAD      ACTIVE   SUB     DESCRIPTION
  abrt-ccpp.service                                   loaded    active   exited  Install ABRT coredump hook
  abrt-oops.service                                   loaded    active   running ABRT kernel log watcher
  abrt-vmcore.service                                 loaded    inactive dead    Harvest vmcores for ABRT
  abrt-xorg.service                                   loaded    active   running ABRT Xorg log watcher
  abrtd.service                                       loaded    active   running ABRT Automated Bug Reporting Tool
  accounts-daemon.service                             loaded    active   running Accounts Service
  alsa-restore.service                                loaded    inactive dead    Save/Restore Sound Card State
  alsa-state.service                                  loaded    active   running Manage Sound Card State (restore and store)
● apparmor.service                                    not-found inactive dead    apparmor.service
  atd.service                                         loaded    active   running Job spooling tools
  auditd.service                                      loaded    active   running Security Auditing Service
```

* ``systemctl help``
Et mostra la pagina del manual asociada al servei especific que nosaltres
posem.
```
systemctl --help
systemctl [OPTIONS...] {COMMAND} ...

Query or send control commands to the systemd manager.

  -h --help           Show this help
     --version        Show package version
     --system         Connect to system manager
     --user           Connect to user service manager
  -H --host=[USER@]HOST
                      Operate on remote host
```

* ``systemctl daemon-reload``
Recarga systemd, escanejant en busca de serveis nous o modificats.
```
systemctl daemon-reload
```

* ``systemd-cgls``
Per veure l'arbre de procesos iniciat per cada servei
```
systemd-cgls
Control group /:
-.slice
├─init.scope
│ └─1 /usr/lib/systemd/systemd --switched-root --system --deserialize 26
├─system.slice
│ ├─avahi-daemon.service
│ │ ├─816 avahi-daemon: running [linux-8.local
│ │ └─822 avahi-daemon: chroot helpe
│ ├─cockpit.service
│ │ ├─2789 /usr/libexec/cockpit-ws
│ │ └─2874 /usr/bin/ssh-agent
```

* ``systemctl kill``
La veritat, es que no conexia aquesta ordre, per lo que he vist, a l'hora
de ver un **kill** a un servei per defecte fa un **SIGTERM** (numero 15
en el llistat al fer ``kill -l``). **SIGTERM** lo que fa es finalitzar
el proces quan ja hagi acabat tot, a diferencia de **SIGKILL** (numero 9
en el llistat), que directament mata el proces i si ha coses per fer
doncs mala sort.

```
systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2017-05-04 08:29:24 CEST; 1s ago
 Main PID: 2833 (httpd)
   Status: "Processing requests..."
    Tasks: 33 (limit: 512)
```
Podem comprobar que el servei **httpd** esta actiu, llavors executem
l'ordre i veiem que passa:

```
systemctl kill httpd

systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: inactive (dead) since Thu 2017-05-04 08:30:18 CEST; 1s ago
  Process: 2833 ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND (code=exited, status=0/SUCCESS)
 Main PID: 2833 (code=exited, status=0/SUCCESS)
   Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Bytes served/sec:   0 B/sec"
```

Com podem comprobar, el servei s'ha aturat ja que no hi ha cap procés
en marxa. Pero me fixat que aquesta ordre te el parametre ``-s`` que
ens permet especificar la senyal que volem enviar.
```
systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2017-05-04 08:32:48 CEST; 3s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
  Process: 2914 ExecStart=/usr/sbin/sshd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 2916 (sshd)
```

Podem comprobar que el servei sshd esta actiu, llavors passem a mirar
els procesos que te corren fent ``ps ax | grep sshd``

```
ps ax | grep sshd
 2916 ?        Ss     0:00 /usr/sbin/sshd
 2929 pts/0    S+     0:00 grep --color=auto sshd
```

Veiem que el nº de proces es el **2916**, ara executem l'ordre amb el
parametre -s i diem que fassi un **SIGHUP** (numero 1 al fer el llistat)
que lo que farà serà reiniciar el servei.
```
systemctl kill -s SIGHUP sshd

[root@i10 ~]# ps ax | grep sshd
 3037 ?        Ss     0:00 /usr/sbin/sshd
```

Es el mateix procediment que si en terminal busquesim el PID del procés
i fessim un ``kill -numero nº proces `` pero m'he donat compte que també
es pot fer en el conjunt de parametres de ``systemctl``.

[systemd]: https://github.com/brianmengibar/projecte-final/blob/master/notes_eines_systemd.md#targets-en-systemd
