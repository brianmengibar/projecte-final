### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
------------------------------------------------------
<!--
# MOVER CRITICAL-CHAIN A eines_visuals?
-->

# Eines per analitzar i gestionar Systemd

En l'altre document ja hem parlat sobre systemd i molts dels seus paràmetres,
si encara no ho habeu llegit, aqui teniu un enllaç per llegir-ho
abans de llegir aquest: [Systemd](notes_systemd.md#que-es-systemd).

## Explorant analyze

L'ordre `systemd-analyze` permet evaluar el proces d'arrencada amb el 
fi de mostrar quines unitats estan ocasionan una demora en el procés 
d'arrencada. Aquestes unitats, fan referencia fundamentalment a:

* serveis (.service)
* punts de montatje (.mount)
* dispositius (.device)
* sockets (.socket)

Una vegada obtinguda tota aquesta informació, es podria optimitzar el sistema
per minimitzar els temps d'arrencada.

### Els seus parametres

A continuació comentaré tots els parametres que te aquesta ordre:

*  `systemd-analyze`

	Que ens mostra una sortida com aquesta
	
	```
	$ systemd-analyze 
		   Startup finished in 765ms (kernel) + 1.654s (initrd) + 15.590s (userspace) = 18.010s
	```

	Aquesta informació general que ens mostra aquesta ordre, es **el temps total
	de l'ultima arrencada del sistema**, especificant:
	
  * El temps empleat en carregar el `kernel`
  * La carrega de `initrd`
  * El temps en l'espai de **l'usuari**

	Al ser distribució __Fedora__, apareix `intird`, en cambi en altres distribucions
	com **Debian/Ubuntu**, no apareixen i la seva assignació de temps es carrega
	en el kernel.

* `systemd-analyze blame`

	Aquest parametre, ens mostra **detalladament**, el temps empleat en carregar
	cadascuna de les unitats, per que no quedi molt extens, filtrarem el resultat
	d'exexutar aquesta ordre amb un `head` per que nomes ens sorti les 10 
	primeres lineas. Llavors, en aquest cas que hem posat `head`, ens sortiren
	les **10 unitats** que trigan mes en carregar-se.

	```
	$ systemd-analyze blame | head
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

* `systemd-analyze critical-chain`

	Aquest parametre es molt util, ja que ens mostra la informació mes gràfica
	a mode d'arbre amb la cadena de units que tenen el major temps de
	carrega a l'hora d'arrencar el sistema

	```
	$ systemd-analyze critical-chain 
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
	
	En el cas de no especificar l'opció **UNIT**, el target que es mostra es el 
	que té el sistema per defecte, es a dir, nosaltres podem visualitzar la grafica
	del target que nosaltres volguem, com per exemple el target `emergency.target`

	```
	$ systemd-analyze critical-chain emergency.target
	The time after the unit is active or started is printed after the "@" character.
	The time the unit takes to start is printed after the "+" character.

	└─fedora-import-state.service @746ms +17ms
	  └─local-fs.target @734ms
		└─run-user-42.mount @12.387s
		  └─local-fs-pre.target @734ms
			└─lvm2-monitor.service @240ms +492ms
			  └─lvm2-lvmetad.service @289ms
				└─lvm2-lvmetad.socket @230ms
				  └─-.slice
	```
	
	Podem observar que abans de la grafica ens surten **dos missatges**:
  * **The time after the unit is active or started is printed after the "@" character**. Aquesta frase esta mal redactada, llavors no podem saber si es refereix quan esta actiu? O estarted.
  * **The time the unit takes to start is printed after the "+" character**. Vol dir que el caracter `+` es el temps que tarda en carregar el servei durant l'arrencada.

#### Targets en systemd

Estem veient que gracies a `systemd-analyze critical-chain [UNIT]` podem
veure les grafiques dels diferents targets del nostre sistema, pero clar,
quins son tots els _Targets Units_ que tenim en el sistema?
A continuació, mostro una taula que contindrà:

* runlevel
* Targets Units
* Descripció

| Runlevel  | Target Units                            | Descripció                                                                   |
|-----------|:---------------------------------------:|-----------------------------------------------------------------------------:|
| 0         | runlevel0.target, `poweroff.target`     | Apaga el sistema                                                             |
| 1         | runlevel1.target, `rescue.target`       | Mode mono-usuari                                                             |
| 2         | runlevel2.target, `multi-user.target`   | Mode inici definit per l'usuari/sistema, per defecte identic a mode 3        |
| 3         | runlevel3.target, `multi-user.target`   | Multiusuari, entorn grafic                                                   |
| 4         | runlevel4.target, `multi-user.target`   | Mode inici definit per l'usuari/sistema, per defecte identic a mode 3        |
| 5         | runlevel5.target, `graphical.target`    | Mutiusuari, entorn grafic, tots els serveis del mode 3 mes un entorn grafic  |
| 6         | runlevel6.target, `reboot.target`       | Reiniciar                                                                    |
| emergency | `emergency.target`                      | Shell d'emergencia                                                           |

* `systemd-analyze time`

	Aquest parametre ens dona el mateix resultat que si executem `systemd-analyze`,
	que tal i com hem dit a dalt es **el temps total de l'ultima arrencada del sistema**, 
	especificant:

  * El temps empleat en carregar el `kernel`
  * La carrega de `initrd`
  * El temps en l'espai de **l'usuari**

* `systemd-analyze dump`

	Aquest parametre dóna sortida __(en general molt llarg)__ a una serialització
	llegible de l'estat del servidor complet. El seu format està subjecta a 
	canvis sense **previ avís** i no ha de ser analitzat per les aplicacions.

	Obviament la sortida es molt mes llarga, pero amb un fragment crec que
	es suficient.

	```
	$ systemd-analyze dump 
	-> Unit multi-user.target:
			Description: Multi-User System
			Instance: n/a
			Unit Load State: loaded
			Unit Active State: active
			State Change Timestamp: Thu 2017-04-27 08:12:54 CEST
			Inactive Exit Timestamp: Thu 2017-04-27 08:12:54 CEST
			Active Enter Timestamp: Thu 2017-04-27 08:12:54 CEST
			Active Exit Timestamp: n/a
			Inactive Enter Timestamp: n/a
			GC Check Good: yes
			Need Daemon Reload: no
			Transient: no
			Slice: n/a
			CGroup: n/a
			CGroup realized: no
			CGroup mask: 0x0
			CGroup members mask: 0x0
			Name: runlevel3.target
			Name: runlevel2.target
			Name: multi-user.target
			Name: runlevel4.target
	```

* `systemd-analyze set-log-level`
	Cambia el nivell de registre actual del daemon de systemd al nivell que
	nosaltres volguem, que per defecte tenim el nivell **info**. Els nivells
	son els de **registre** que tenim en el sistema (en l'altre 
	[document](reports_elaborats.md#per-prioritat) podeu veure una petita
	taula amb el significat de cada nivell).

  * **emerg**
  * **alert**
  * **crit**
  * **err**
  * **warning**
  * **notice**
  * **info**
  * **debug**

* `systemd-analyze set-log-target`
	Cambia el target del registre actual del daemon de systemd al target que
	nosaltres volguem, que per defecte en aquest moment tenim el target
	**graphical.target**. Els targets com els hem anomenat abans son:

  * **poweroff.target**
  * **rescue.target**
  * **multi-user.target**
  * **graphical.target**
  * **reboot.target**

* `systemd-analyze verify`
	Una eina molt util que ens carrega files _"unit"_ (.socket, .mount, .device...),
	si en algun _"unit"_ es detecten errors es printaran per pantalla, en el cas contrari
	automaticament no sortira res per pantalla.

	**Verifiquem http.service**:

	```
	$ systemd-analyze verify /usr/lib/systemd/system/httpd.service && echo "Si surt aquest missatge? Tot be"
	Si surt aquest missatge? Tot be
	```

	**Verifiquem sftp.mount**:

	```
	$ systemd-analyze verify /usr/share/gvfs/mounts/sftp.mount
	[/usr/share/gvfs/mounts/sftp.mount:3] Unknown lvalue 'Exec' in section 'Mount'
	[/usr/share/gvfs/mounts/sftp.mount:4] Unknown lvalue 'AutoMount' in section 'Mount'
	[/usr/share/gvfs/mounts/sftp.mount:5] Unknown lvalue 'Scheme' in section 'Mount'
	[/usr/share/gvfs/mounts/sftp.mount:6] Unknown lvalue 'SchemeAliases' in section 'Mount'
	[/usr/share/gvfs/mounts/sftp.mount:7] Unknown lvalue 'DefaultPort' in section 'Mount'
	[/usr/share/gvfs/mounts/sftp.mount:8] Unknown lvalue 'HostnameIsInetAddress' in section 'Mount'
	sftp.mount: What= setting is missing. Refusing.
	sftp.mount: Failed to create sftp.mount/start: Unit sftp.mount is not loaded properly: Bad message.
	```

	Comprovem que aquest _"unit"_ te linies erroneas i a l'hora de verificar ens donen
	els **missatges d'error**.

## Les seves opcions

Una vegada hem vist tots els parametres que té l'ordre `systemd-analyze`,
paso a comentar totes les opcions que té que son aquestes:

* `--user`
	Si posem aquesta opció, significa que funcionara en l'espai de l'usuari,
	es a dir, per que quedi mes clar posare un exemple:

	```
	$ systemd-analyze blame --user
			   154ms evolution-source-registry.service
			   150ms evolution-calendar-factory.service
				89ms evolution-addressbook-factory.service
				88ms gvfs-goa-volume-monitor.service
				57ms gnome-terminal-server.service
				16ms at-spi-dbus-bus.service
				14ms gvfs-udisks2-volume-monitor.service
				11ms gvfs-daemon.service
				 8ms gvfs-gphoto2-volume-monitor.service
				 5ms gvfs-afc-volume-monitor.service
				 5ms gvfs-mtp-volume-monitor.service
				 3ms gvfs-metadata.service
				 3ms dbus.socket
	```

	Com hem dit a dalt, `blame` ens mostra **detalladament**, el temps 
	empleat en carregar cadascuna de les unitats que **SON NECESSARIES PER
	AQUEST USUARI**.

* `--system`
	Aquesta opció mostra lo mateix que si executem `systemd-analyze` sense
	parametres i opcions.

	```
	$ systemd-analyze blame --system
			 15.093s plymouth-quit-wait.service
			 12.350s mariadb.service
			 12.102s postgresql.service
			 11.464s udisks2.service
			 11.365s accounts-daemon.service
			 11.176s polkit.service
			  2.445s dovecot.service
			  1.039s plymouth-start.service
			   696ms httpd.service
			   615ms postfix.service
			   485ms libvirtd.service
			   469ms lvm2-monitor.service
			   384ms lvm2-pvscan@9:0.service
	```

* `--host`
	Aquesta opció ens permet executar l'ordre remotament, cal especificar
	el nom de l'usuari i nom del host, obviament separat per **@**, es la mateixa
	sintaxis. Cal dir que es necessari que les dues maquines tinguin el servei
	`ssh` engegat.

	```
	$ systemd-analyze blame --host=root@i12
	root@i12's password: 
			  3.658s plymouth-quit-wait.service
			  1.273s mariadb.service
			  1.162s postgresql.service
			  1.044s plymouth-start.service
			   727ms mongod.service
			   560ms postfix.service
			   497ms libvirtd.service
			   494ms httpd.service
			   328ms dev-sda5.device
			   287ms named.service
			   255ms systemd-journald.service
			   208ms lvm2-monitor.service
			   207ms lvm2-pvscan@9:0.service
	```

	Com podem comprobar, al fer l'ordre ens demana el password de l'altre
	usuari, en el moment que la posem ens surt el llistat dels units que han
	tardat mes en arrencar aquella maquina.

* `--no-pager`
	Aquesta opció, provoca que no es produeixi un _"pipe"_ de la sortida 
	STANDARD

	```
	$ systemd-analyze blame --no-pager
			 15.093s plymouth-quit-wait.service
			 12.350s mariadb.service
			 12.102s postgresql.service
			 11.464s udisks2.service
			 11.365s accounts-daemon.service
			 11.176s polkit.service
			 3ms var-lib-nfs-rpc_pipefs.mount
			 3ms systemd-update-utmp-runlevel.service
			 3ms dracut-shutdown.service
			 1ms sys-kernel-config.mount
	$ 
	```

	Clarament he tallat el resultat, ja que si no seria un resultat molt 
	extens.

* `--help`

	Et mostra una petita pagina d'ajuda amb les comandes mes __interesants__.

	```
	$ systemd-analyze --help
	systemd-analyze [OPTIONS...] {COMMAND} ...

	Profile systemd, show unit dependencies, check unit files.

	  -h --help               Show this help
		 --version            Show package version
		 --no-pager           Do not pipe output into a pager
		 --system             Operate on system systemd instance
		 --user               Operate on user systemd instance
	  -H --host=[USER@]HOST   Operate on remote host
	  -M --machine=CONTAINER  Operate on local container
		 --order              Show only order in the graph
		 --require            Show only requirement in the graph
		 --from-pattern=GLOB  Show only origins in the graph
		 --to-pattern=GLOB    Show only destinations in the graph
		 --fuzz=SECONDS       Also print also services which finished SECONDS
							  earlier than the latest in the branch
		 --man[=BOOL]         Do [not] check for existence of man pages

	Commands:
	  time                    Print time spent in the kernel
	  blame                   Print list of running units ordered by time to init
	  critical-chain          Print a tree of the time critical chain of units
	  plot                    Output SVG graphic showing service initialization
	  dot                     Output dependency graph in dot(1) format
	  set-log-level LEVEL     Set logging threshold for manager
	  set-log-target TARGET   Set logging target for manager
	  dump                    Output state serialization of service manager
	  verify FILE...          Check unit files for correctness
	```
