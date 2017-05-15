### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
------------------------------------------------------

# Systemd

## Que es Systemd?

És un gestor del sistema i dels serveis per a Linux, compatible amb els 
`initscript SysV i LSB`. Systemd proporciona una notable capacitat de 
paral·lelització, utilitza l'activació de socket i D-Bus per iniciar 
els serveis, permet l'inici dels daemons sota demanda, realitza un 
seguiment dels processos amb l'ús dels grups de control de Linux, dóna 
suport _snapshotting_ i la restauració de l'estat del sistema, manté els 
punts muntatge i serveis de muntatge automàtic e implementa un elaborat 
sistema de gestió de dependències basat en un control lògic dels serveis.

## Us basic de systemd

La principal ordre per controlar _systemd_ es `systemctl`. Quina utilitat
te? **Controlar el sistema i gestor de serveis systemd**. Per mes informació
sobre l'ordre `systemctl` podem consultar  des de la nostra consola
`man systemctl(1)`. Cal mencionar que en el moment que volem engegar, aturar,
veure l'estat, etc d'un servei, sempre caldra ser **root**.

## Analitzar l'estat del sistema

A continuació comentaré una serie d'ordres de la familia systemd:

* `systemctl list-units`

	Amb aquesta ordre podem llistar les unitats que tenim en execució.

	```
	$ systemctl list-units
	UNIT                                                                                                       LOAD   ACTIVE SUB       DESCRIPTION
	proc-sys-fs-binfmt_misc.automount                                                                          loaded active waiting   Arbitrary Executable File Formats File System Automount Point
	sys-devices-pci0000:00-0000:00:02.0-backlight-acpi_video0.device                                           loaded active plugged   /sys/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0
	sys-devices-pci0000:00-0000:00:02.0-drm-card0-card0\x2dLVDS\x2d1-intel_backlight.device                    loaded active plugged   /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight
	sys-devices-pci0000:00-0000:00:1b.0-sound-card0.device                                                     loaded active plugged   82801I (ICH9 Family) HD Audio Controller
	sys-devices-pci0000:00-0000:00:1c.0-0000:02:00.0-net-wlo1.device                                           loaded active plugged   RTL8191SEvA Wireless LAN Controller
	sys-devices-pci0000:00-0000:00:1c.1-0000:03:00.0-net-enp3s0.device                                         loaded active plugged   RTL8101/2/6E PCI Express Fast/Gigabit Ethernet controller
	```

* `systemctl list-units -t`

	Amb el parametre `-t`, podem veure per exemple tots els targets del sistema **actius**.

	```
	$ systemctl list-units -t target 
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

	Llavors, gracies al parametre `--all` podem veure tots els units .targets del sistema, ja estiguin **actius** o **inactius**.
	
	```
	$ systemctl list-units -t target --all 
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

	Cal mencionar que no només podem veure amb -t els targets, si no que
	podem veure tots els units (**automount, busname, device, mount, path, scope,
	service, slice, socket, swap, timer**)

* `systemctl isolate`

	Opció molt util, ja que amb `isolate` podem pasar d'un runlevel a un altre.
	```
	systemctl isolate 
	ctrl-alt-del.target         halt.target                 multi-user.target           runlevel1.target            runlevel6.target
	default.target              initrd-switch-root.service  poweroff.target             runlevel2.target            system-update.target
	emergency.target            initrd-switch-root.target   reboot.target               runlevel3.target            
	exit.target                 initrd.target               rescue.target               runlevel4.target            
	graphical.target            kexec.target                runlevel0.target            runlevel5.target    
	```

	Al donar-li al tabulador veiem tots els targets en els qual podem accedir.


	Cal dir que la explicació dels runlevels i targets ho tenim en l'altre
	document on seguim parlant sobre [systemd].

* `systemctl get-default`

	Gràcies a aquesta opció, podem sapiguer en quin target estem actualment
	en aquest sistema, per cambiar de target, ho fariem amb l'opció `ìsolate`
	que he comentat abans.

	```
	$ systemctl get-default 
		graphical.target
	```

* `systemctl set-default`

	A vegades es pot donar el cas de que estem en un target en concret pero
	que d'aqui dues hores volem estar per exemple en mode __rescue__, doncs be,
	en comptes de fer `systemctl isolate rescue.target`, podem fer
	`systemctl set-default rescue.target`, aixó que fa? Doncs que ara per
	defecte s'iniciara en mode __rescue__, ja que a esborrar l'antic
	`symbolic link` que apuntaba a __graphical.target__ i a creat un nou
	`symbolic link` que apunta a __rescue.target__.
	
	```
	$ systemctl set-default rescue.target 
	Removed symlink /etc/systemd/system/default.target.
	Created symlink from /etc/systemd/system/default.target to /usr/lib/systemd/system/rescue.target.
	```

	I llavors comprovem:
	
	```
	$ systemctl get-default 
		rescue.target
	```

	Ara si fessim un reboot, automaticament entrariem en mode __rescue__.

* `systemctl list-unit-files`

	Les unitats disponibles es troben llistades en els directoris **/lib/systemd/system**
	i en **/etc/systemd/system**. Pero amb aquesta opció, tambe es poden llistar.
	Que ens dona aixo? La llista de les unitats disponibles i l'estatus de cadascuna.
	
	```
	$ systemctl list-unit-files
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

* `systemctl start service`

	Ens permet poder engegar un servei.
	
	```
	$ systemctl start sshd

	$ systemctl status sshd
	● sshd.service - OpenSSH server daemon
	   Loaded: loaded (/etc/systemd/system/sshd.service; disabled; vendor preset: disabled)
	   Active: active (running) since Mon 2017-05-15 10:09:45 CEST; 2s ago
		 Docs: man:sshd(8)
			   man:sshd_config(5)
	  Process: 19167 ExecStart=/usr/sbin/sshd $OPTIONS (code=exited, status=0/SUCCESS)
	 Main PID: 19172 (sshd)
		Tasks: 1 (limit: 512)
	   CGroup: /system.slice/sshd.service
			   └─19172 /usr/sbin/sshd

	May 15 10:09:45 i10 systemd[1]: Starting OpenSSH server daemon...
	May 15 10:09:45 i10 sshd[19172]: Server listening on 0.0.0.0 port 22.
	May 15 10:09:45 i10 sshd[19172]: Server listening on :: port 22.
	May 15 10:09:45 i10 systemd[1]: Started OpenSSH server daemon.
	```

* `systemctl stop service`

	Ens permet poder aturar un servei.
	
	```
	$ systemctl stop sshd

	$ systemctl status sshd
	● sshd.service - OpenSSH server daemon
	   Loaded: loaded (/etc/systemd/system/sshd.service; disabled; vendor preset: disabled)
	   Active: inactive (dead)
		 Docs: man:sshd(8)
			   man:sshd_config(5)

	May 15 10:09:45 i10 systemd[1]: Starting OpenSSH server daemon...
	May 15 10:09:45 i10 sshd[19172]: Server listening on 0.0.0.0 port 22.
	May 15 10:09:45 i10 sshd[19172]: Server listening on :: port 22.
	May 15 10:09:45 i10 systemd[1]: Started OpenSSH server daemon.
	May 15 10:10:03 i10 systemd[1]: Stopping OpenSSH server daemon...
	May 15 10:10:03 i10 sshd[19172]: Received signal 15; terminating.
	May 15 10:10:03 i10 systemd[1]: Stopped OpenSSH server daemon.
	```

* `systemctl restart service`

	Ens permet poder reiniciar un servei.

* `systemctl try-restart service`

	Similar a `systemctl restart` pero aquesta renicia el servei si s'esta
	executant, es a dir, si el servei esta aturat? Aquesta ordre no farà 
	**res**.

* `systemctl reboot`

	Ens permet reiniciar el sistema

* `systemctl poweroff`

	Ens permet apagar el sistema

* `systemctl halt`

	Ens permet tancar **tot** i apagar el sistema

* `systemctl status`

	Ens mostra l'estat del servei, inclós si esta en execució o no. A part
	de tambe mostrar-nos un petit log com el que fa `journalctl` pero
	molt mes breu, encara que a vegades quan no sabem per que no s'engega
	el servei ens pot ser util.
	
	```
	$ systemctl status httpd
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

* `systemctl enable`

	Ens habilita el servei per que a partir d'ara, en el moment que s'arranqui
	el sistema, aquest servei ja s'inici automaticament.
	
	```
	$ systemctl enable sshd
	Created symlink from /etc/systemd/system/multi-user.target.wants/sshd.service to /usr/lib/systemd/system/sshd.service.
	```
	
	En el moment que fem enable, es crea un `symbolic link`, per que aixi
	el sistema sapiga que en el moment que s'arranqui el sistema, calgui engegar
	aquest servei.

* `systemctl disable`

	Ens deshabilita el servei per que a partir d'ara, en el moment que s'arranqui
	el sistema, aquest servei no s'inici automaticament, aixi que s'esborra el
	`symbolic link`.
	
	```
	$ systemctl disable sshd
	
	Removed symlink /etc/systemd/system/multi-user.target.wants/sshd.service.
	```

* `systemctl is-enabled`

	$ Molt util per comprobar si un servei especific ja esta habilitat o no.
	
	```
	systemctl is-enabled sshd
	disabled

	systemctl is-enabled httpd
	enabled
	```

* `systemctl is-active`
	Aquesta opció ens diu si un servei esta engegat o no.
	
	```
	$ systemctl is-active dovecot
	inactive

	$ systemctl is-active httpd
	active
	```

* `systemctl -t`

	S'utilitza per llistar per exemple els units .services que tenim en el 
	sistema **actius**.
	
	```
	$ systemctl -t service
	  UNIT                                            LOAD   ACTIVE SUB     DESCRIPTION
	  abrt-ccpp.service                               loaded active exited  Install ABRT coredump hook
	  abrt-oops.service                               loaded active running ABRT kernel log watcher
	  abrt-xorg.service                               loaded active running ABRT Xorg log watcher
	  abrtd.service                                   loaded active running ABRT Automated Bug Reporting Tool
	  accounts-daemon.service                         loaded active running Accounts Service
	  alsa-state.service                              loaded active running Manage Sound Card State (restore and store)
	  atd.service                                     loaded active running Job spooling tools
	```

	Gracies al parametre `-a`, es mostren tots els serveis, ja estiguin 
	**actius** o **inactius**.

	```
	$ systemctl -t service -a
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

	Cal mencionar que també en aquesta ordre, no només podem veure els .services,
	si no que podem veure tots els units (**automount, busname, device, mount,
	path, scope, slice, socket, swap, target, timer**)

* `systemctl help`

	Et mostra la pagina del manual asociada al servei especific que nosaltres
	posem.
	
	```
	$ systemctl --help
	systemctl [OPTIONS...] {COMMAND} ...

	Query or send control commands to the systemd manager.

	  -h --help           Show this help
		 --version        Show package version
		 --system         Connect to system manager
		 --user           Connect to user service manager
	  -H --host=[USER@]HOST
						  Operate on remote host
	```

* `systemctl daemon-reload`

	Recarga systemd, escanejant en busca de serveis nous o modificats.

* `systemd-cgls`

	Per veure l'arbre de procesos iniciat per cada servei.
	
	```
	$ systemd-cgls
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

* `systemctl kill`

	La veritat, es que no conexia aquesta ordre, per lo que he vist, a l'hora
	de ver un **kill** a un servei per defecte fa un **SIGTERM** (numero 15
	en el llistat al fer `kill -l`). **SIGTERM** lo que fa es finalitzar
	el proces quan ja hagi acabat tot, a diferencia de **SIGKILL** (numero 9
	en el llistat), que directament mata el proces i si ha coses per fer
	doncs mala sort.

	```
	$ systemctl status httpd
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
	$ systemctl kill httpd

	$ systemctl status httpd
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
	$ systemctl status sshd
	● sshd.service - OpenSSH server daemon
	   Loaded: loaded (/usr/lib/systemd/system/sshd.service; disabled; vendor preset: disabled)
	   Active: active (running) since Thu 2017-05-04 08:32:48 CEST; 3s ago
		 Docs: man:sshd(8)
			   man:sshd_config(5)
	  Process: 2914 ExecStart=/usr/sbin/sshd $OPTIONS (code=exited, status=0/SUCCESS)
	 Main PID: 2916 (sshd)
	```

	Podem comprobar que el servei sshd esta actiu, llavors passem a mirar
	els procesos que te corren fent `ps ax | grep sshd`

	```
	$ ps ax | grep sshd
	 2916 ?        Ss     0:00 /usr/sbin/sshd
	 2929 pts/0    S+     0:00 grep --color=auto sshd
	```

	Veiem que el nº de proces es el **2916**, ara executem l'ordre amb el
	parametre -s i diem que fassi un **SIGHUP** (numero 1 al fer el llistat)
	que lo que farà serà reiniciar el servei.
	
	```
	$ systemctl kill -s SIGHUP sshd

	$ ps ax | grep sshd
	 3037 ?        Ss     0:00 /usr/sbin/sshd
	```

	Es el mateix procediment que si en terminal busquesim el PID del procés
	i fessim un `kill -numero nº proces` pero m'he donat compte que també
	es pot fer en el conjunt de parametres de `systemctl`.

* `systemctl mask servei.service`

	Aquest parametre no ho coneixia i la veritat es que la veig molt util,
	a l'hora d'emmascarar un servei, a part de deshabilitar-ho, evitem que
	es pugui iniciar ja sigui manualment o automaticament.

	Lo primer que hi ha que comprobar es mostrar que el servei **sshd** esta
	engegat.
	
	```
	$ systemctl status sshd
	● sshd.service - OpenSSH server daemon
	   Loaded: loaded (/usr/lib/systemd/system/sshd.service; disabled; vendor preset: disabled)
	   Active: active (running) since Thu 2017-05-04 10:12:07 CEST; 39s ago
		 Docs: man:sshd(8)
			   man:sshd_config(5)
	```

	Llavors, ara executem l'ordre per que es deshabiliti i aixi que no es
	pugui iniciar

	```
	$ systemctl mask sshd
	Created symlink from /etc/systemd/system/sshd.service to /dev/null.
	```

	Ojo, el servei com esta engegat? Si que el podem aturar, pero clar,
	despres llavors no podem engegar-ho per que te el link creat.

	Una vegada creat, tornem a comprobar que el servei segueix actiu i
	l'aturem.
	
	```
	$ systemctl status sshd
	● sshd.service
	   Loaded: masked (/dev/null; bad)
	   Active: active (running) since Thu 2017-05-04 10:12:07 CEST; 7min ago
	 Main PID: 4356 (sshd)
	   CGroup: /system.slice/sshd.service
			   └─4356 /usr/sbin/sshd

	$ systemctl stop sshd
	```

	Llavors, ara l'unic que falta es comprobar que el servei sshd no es pot
	iniciar.
	
	```
	$ systemctl start sshd
	Failed to start sshd.service: Unit sshd.service is masked.
	```

	I com tenia que ser, ens diu que no es pot iniciar per que aquest servei
	esta **enmasquerat**.

* `systemctl unmask servei.service`

	Clarament, serveix per per desemmascarar un servei.
	
	```
	$ systemctl unmask sshd
	Removed symlink /etc/systemd/system/sshd.service.
	```

	En el moment que desemmascarem el servei, tornem a intentar engegar el
	servei.
	
	```
	$ systemctl start sshd

	$ systemctl status sshd
	● sshd.service - OpenSSH server daemon
	   Loaded: loaded (/usr/lib/systemd/system/sshd.service; disabled; vendor preset: disabled)
	   Active: active (running) since Thu 2017-05-04 10:24:53 CEST; 13s ago
		 Docs: man:sshd(8)
			   man:sshd_config(5)
	```

	Tot torna a la normalitat i en funcionament.

* `systemctl list-dependencies`

	Aquest parametre ens pot servir per sapiguer la dependencia d'un
	unit especific o per defecte, si no especifiquem res, ens mostra tots 
	els units que depenen del target actual que te el sistema
	
	```
	$ systemctl list-dependencies 
	default.target
	● ├─accounts-daemon.service
	● ├─gdm.service
	● ├─rtkit-daemon.service
	● ├─systemd-update-utmp-runlevel.service
	● ├─udisks2.service
	● └─multi-user.target
	●   ├─abrt-ccpp.service
	●   ├─abrt-oops.service
	●   ├─abrt-vmcore.service
	●   ├─abrt-xorg.service
	```

	Com podem comprobar ens surt **default.target** que sabem que es **graphical.target**
	ja que ho podem confirmar fent l'ordre `systemctl get-default` (ja comentada
	a dalt). Clarament no fico tot el resultat per que no sigui massa extens.

	Ara hem vist tots els units que depenen de **default.target**, podem
	també especificar un unit com per exemple, que ens mostri tots els
	units que depenen de **reboot.target**.
	
	```
	$ systemctl list-dependencies reboot.target 
	reboot.target
	● ├─plymouth-reboot.service
	● └─systemd-reboot.service
	```

	O per exemple que ens mostri tots els units que depenen del servei
	**sshd**.
	
	```
	$ systemctl list-dependencies sshd
	sshd.service
	● ├─system.slice
	● ├─sshd-keygen.target
	● │ ├─sshd-keygen@ecdsa.service
	● │ ├─sshd-keygen@ed25519.service
	● │ └─sshd-keygen@rsa.service
	● ├─sshd-keygen.target
	● │ ├─sshd-keygen@ecdsa.service
	● │ ├─sshd-keygen@ed25519.service
	● │ └─sshd-keygen@rsa.service
	● └─sysinit.target
	```

	Després de veure varis exemples, m'he donat compte de que també podem
	especificar si volem veure els units que depenen abans d'un unit especific
	els units que depenen de despres d'un unit especific, etc.

  * `systemctl list-dependencies unit --before`
  
     Amb aquesta opció estem dient que ens mostri tots els units **ordenats** que van 
     __abans__ d'aquest unit especific. Per exemple mirarem el servei **httpd**.
     
	```
	$ systemctl list-dependencies --before httpd
	httpd.service
	● ├─multi-user.target
	● │ ├─systemd-update-utmp-runlevel.service
	● │ └─graphical.target
	● │   └─systemd-update-utmp-runlevel.service
	● └─shutdown.target
	```

  * `systemctl list-dependencies --after unit`
  
     Per lo que he deduït, en teoria `--after` es l'inversa de `--before`, es a dir, ens 
     mostra tots els units **ordenats** que van __despres__ d'aquest unit 
     específic. Per exemple tornarem a mirar el servei **httpd**.
     
	```
	$ systemctl list-dependencies --after httpd
	httpd.service
	● ├─-.mount
	● ├─system.slice
	● ├─systemd-journald.socket
	● ├─tmp.mount
	● ├─basic.target
	● │ ├─-.mount
	● │ ├─dnf-makecache.timer
	● │ ├─fedora-import-state.service
	● │ ├─systemd-ask-password-plymouth.path
	● │ ├─tmp.mount
	```
	
	 No poso tot el resultat perque si no es massa extens.
  
  * `systemctl list-dependencies --reverse unit`
     Amb `--reverse` en mostra les dependències inverses, es a dir, mostra les dependències
     de tipus **WantedBy =, RequiredBy =, partof =, BOUNDBY =, 
     **en lloc de **Wants = i similar**.
     
	```
	httpd.service
	● └─multi-user.target
	●   └─graphical.target
	```

  * `systemctl list-dependencies --all unit` 
    Per lo que veig, quan possem ``--all``, totes les altres unitats 
    també s'expandeixen de forma recursiva.
    
	```
	$ systemctl list-dependencies --all httpd
	httpd.service
	● ├─-.mount
	● │ ├─quotaon.service
	● │ │ └─system.slice
	● │ │   └─-.slice
	● │ ├─system.slice
	● │ │ └─-.slice
	● │ └─systemd-quotacheck.service
	● │   └─system.slice
	● │     └─-.slice
	```

	 No poso totes les linies ja que al utilitzar `--all` tots els units
	 es despleguen i he vist que surten 481 linies.

* ``systemctl cat service``

	Explorant, he trobat que `systemctl` també té el parametre `cat`, que
	crec que es molt util, ja que aquest parametre seguit d'un servei, ens
	mostra el fitxer de configuració del servei i també ens mostra la ruta
	de on esta ubicat el servei. Molt util per quan volem editar el fitxer
	i no ens recordem o no sabem on pot estar el fitxer la veritat.
	
	```
	$ systemctl cat sshd.service
	# /usr/lib/systemd/system/sshd.service
	[Unit]
	Description=OpenSSH server daemon
	Documentation=man:sshd(8) man:sshd_config(5)
	After=network.target sshd-keygen.target
	Wants=sshd-keygen.target

	[Service]
	Type=forking
	PIDFile=/var/run/sshd.pid
	EnvironmentFile=-/etc/sysconfig/sshd
	ExecStart=/usr/sbin/sshd $OPTIONS
	ExecReload=/bin/kill -HUP $MAINPID
	KillMode=process
	Restart=on-failure
	RestartSec=42s

	[Install]
	WantedBy=multi-user.target
	```

* `systemctl edit --full service`

	Obviament, si `systemctl` permet fer un cat del fitxer de configuració,
	te que existir un altre parametre per poder modificar el fitxer, doncs
	be, per poder fer-ho es posant **edit** seguit de `--full`. Aixó
	significa que directament anirà a editar el fitxer de configuració, si
	no fiquessim `--edit` s'obriria un fitxer en blanc que el podriem 
	utilitzar per anul·lar o afegir directives al fitxer de configuració.
	
	```
	$ systemctl edit --full sshd
	[Unit]
	Description=OpenSSH server daemon
	Documentation=man:sshd(8) man:sshd_config(5)
	After=network.target sshd-keygen.target
	Wants=sshd-keygen.target

	[Service]
	Type=forking
	PIDFile=/var/run/sshd.pid
	EnvironmentFile=-/etc/sysconfig/sshd
	ExecStart=/usr/sbin/sshd $OPTIONS
	ExecReload=/bin/kill -HUP $MAINPID
	KillMode=process
	Restart=on-failure
	RestartSec=42s

	[Install]
	WantedBy=multi-user.target
	"/etc/systemd/system/.#sshd.servicead9647d9cc20c510" 18L, 396C 
	```

	Clarament al fer aquesta ordre no surt el contingut, pero per aixo a 
	sota fico la directiva que surt al editar el fitxer.

	Si editem el fitxer, cal recordar que tindriem que fer `systemctl daemon
	reload` per que acceptar els cambis fets.

* `systemctl show [service]`

	Aquest parametre mostra una llista de propietats que s'estableixen per
	l'unitat especificada. Si no especifiquem cap unit, automaticament es
	mostraran les propietats del nostre sistema.
	
	```
	$ systemctl show
	Version=229
	Features=+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN
	Architecture=x86-64
	FirmwareTimestampMonotonic=0
	LoaderTimestampMonotonic=0
	KernelTimestamp=Thu 2017-05-11 08:07:57 CEST
	KernelTimestampMonotonic=0
	InitRDTimestamp=Thu 2017-05-11 08:07:58 CEST
	InitRDTimestampMonotonic=773454
	UserspaceTimestamp=Thu 2017-05-11 08:08:00 CEST
	UserspaceTimestampMonotonic=2488979
	```

	Cal mencionar que no poso tota l'informació per que son 86 linias i seria molt extens.

	Ara ho executem pero per exemple amb el servei httpd.
	
	```
	$ systemctl show httpd
	Type=notify
	Restart=no
	NotifyAccess=main
	RestartUSec=100ms
	TimeoutStartUSec=1min 30s
	TimeoutStopUSec=1min 30s
	RuntimeMaxUSec=infinity
	WatchdogUSec=0
	WatchdogTimestamp=Thu 2017-05-11 08:08:01 CEST
	```

	Idem que a dalt, massa linies.

	Com podem comprobar, clarament no ens dona la mateixa informació, ja
	que ara ens mostra la llista de propietats a baix nivell d'aquest
	servei especific. Clarament no cal que sigui un `.service`, per exemple
	podem veure tot el llistat de `rescue.target`.
	
	```
	$ systemctl show rescue.target
	Id=rescue.target
	Names=runlevel1.target rescue.target
	Requires=sysinit.target rescue.service
	Wants=systemd-update-utmp-runlevel.service
	Conflicts=shutdown.target
	ConflictedBy=graphical.target multi-user.target
	Before=systemd-update-utmp-runlevel.service graphical.target multi-user.target
	After=sysinit.target rescue.service
	```

	Es pot donar el cas de que de tot el llistat nomes volguem una linea o dos,
	podem fer el tipic `grep` i filtrar, pero clar, per que fer aixo
	quan `systemctl` ja te un parametre per poder buscar anomenat `--property`.
	Que ens permet? Buscar nomes les propietats que nosaltres volguem com
	per exemple veure la propietat **Names** del target `graphical.target`.
	
	```
	$ systemctl show --property Names graphical.target
	Names=graphical.target runlevel5.target
	```

	O si volem més d'una propietat, podem ficar-las separades per comes:
	
	```
	$ systemctl show --property Names,Documentation graphical.target
	Names=graphical.target runlevel5.target
	Documentation=man:systemd.special(7)
	```

	Pero que passa si volem veure les mateixes propietats pero per diferents
	units? Doncs també podem, com? Separant cada unit amb un espai:
	
	```
	$ systemctl show --property Names,Requires graphical.target httpd sshd rescue.target
	Names=graphical.target runlevel5.target
	Requires=multi-user.target

	Names=httpd.service
	Requires=-.mount system.slice sysinit.target tmp.mount

	Names=sshd.service
	Requires=system.slice sysinit.target

	Names=runlevel1.target rescue.target
	Requires=sysinit.target rescue.service
	```

* `sytemctl --failed`

	Amb aquest parametre ens llista les unitats
	que han tingut algun problema i per aixo no estan actives.
	
	```
	$ systemctl --failed
	  UNIT                              LOAD   ACTIVE SUB    DESCRIPTION
	● mdmonitor.service                 loaded failed failed Software RAID monitoring and management
	● vncserver@:display_number.service loaded failed failed Remote desktop service (VNC)

	LOAD   = Reflects whether the unit definition was properly loaded.
	ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
	SUB    = The low-level unit activation state, values depend on unit type.

	2 loaded units listed. Pass --all to see loaded but inactive units, too.
	To show all installed unit files use 'systemctl list-unit-files'.
	```

[systemd]: notes_eines_systemd.md#targets-en-systemd
