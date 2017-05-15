### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
----------------------------------------------

# Journal

## Que es journal?

És un component de `systemd` que és responsable de la **visualització i 
gestió d'arxius de registre.** Va ser desenvolupat per fer front als 
problemes relacionats amb l'explotació tradicional. 
Està estrictament integrat amb la resta del sistema, és compatible amb 
diverses tecnologies de registre i gestió d'accés per als arxius de 
registre.

El registre de dades es recull, emmagatzema i processa a través del 
servei `journald`. Es crea i manté arxius binaris anomenats 
**journalds** sobre la base de la informació de registre que es rep des de:

* El nucli
* A partir dels processos dels usuaris
* Sortida estandard
* Sortida d'error dels serveis del sistema
 
Aquests `journals` estan estructurats e indexats, aixo fa que es
proporcioni relativament una rapida busqueda. Les entrades de journals
poden portar un identificador **únic.** El servei `journald` recull nombrosos 
camps de metadades per a cada missatge de registre. Els arxius de journal 
reals estan assegurats, i per tant **no es poden editar manualment.**

## Visualització de registres

Bé, per accedir als logs de `journal` s'utilitza l'eina `journalctl`.
Que mostra journalctl? Doncs una llista de tots els fitxers de registre
generats en el sistema, incloent missatges generats pel sistema o per els
propis usuaris.

## Que ens proporcionen aquests fitxers?

* Línies de prioritat més alta d'error i es destaquen en color **vermell** 
i amb una font en **negreta**, s'utilitza per a línies amb notificació i
prioritat d'alerta.
* Les marques de temps es converteixen per a la zona horària local del nostre sistema.
* El començament d'una arrencada de sistema esta marcat amb una línia diferent

## Parametres de journalctl

A continuació es mostraran una serie de parametres que conte l'ordre
``journalctl``:

* `journalctl`

	Per defecte, si utilitzem l'ordre sense arguments, mostra tots els 
	continguts del `journal`, començant amb l'entrada més antiga que va ser guardada.

	Cal dir que per defecte, les entrades més antigues es mostren 
	al principi. La sortida és mostrada per la sortida standard i no es veu 
	tota l'informacio ja que les línies estan truncades, tot i això podem 
	moure'ns amb les tecles del cursor a esquerra i dreta per veure el 
	contingut complet. I si volem veure les altres entrades, podem pressionar 
	la tecla **d'espai** per desplaçar-nos pantalles senceres cap a munt, i 
	cap avall.

	```
	$ journalctl
	-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:01:01 CEST. --
	sep 15 19:55:07 localhost.localdomain systemd-journald[158]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
	sep 15 19:55:07 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
	sep 15 19:55:07 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 2016
	sep 15 19:55:07 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe
	sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
	sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
	sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Enabled xstate features 0x3, context size is 576 bytes, using 'standard' format.
	```

* `journalctl -n nombre`

	En molts casos, només les últimes entrades al registre journal són 
	rellevants. Gracies al parametre `-n` podem especificar les ultimes **n**
	linies que volem veure.
	
	```
	$ journalctl -n 5
	-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:01:01 CEST. --
	abr 25 20:00:21 localhost.localdomain PackageKit[1169]: search-file transaction /739_aebaedba from uid 1000 finished with success after 246ms
	abr 25 20:00:21 localhost.localdomain PackageKit[1169]: search-file transaction /740_ebceaebe from uid 1000 finished with success after 246ms
	abr 25 20:01:01 localhost.localdomain CROND[4730]: (root) CMD (run-parts /etc/cron.hourly)
	abr 25 20:01:01 localhost.localdomain run-parts[4733]: (/etc/cron.hourly) starting 0anacron
	abr 25 20:01:01 localhost.localdomain run-parts[4739]: (/etc/cron.hourly) finished 0anacron
	```

* `journalctl -o option`

	L'ordre `journalctl` permet controlar la forma de la sortida gracies
	al parametre `-o`, cal substituir `option` amb una paraula clau que 
	especifiqui una forma desitjada de sortida. Hi ha diverses opcions com:
	
   * `verbose`
   
		Que retorna els elements amb tots els camps.
		
		```
		$ journalctl -o verbose
		-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:01:01 CEST. --
		jue 2016-09-15 19:55:07.160306 CEST [s=78aab514ed50497e9d0c225a94bdc38a;i=1;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fcb7;t=53c8f8bcf46f2;x=11b855cd1e83
		SYSLOG_FACILITY=3
		SYSLOG_IDENTIFIER=systemd-journald
		_TRANSPORT=driver
		PRIORITY=6
		MESSAGE_ID=ec387f577b844b8fa948f33cad9a75e6
		MESSAGE=Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
		JOURNAL_NAME=Runtime journal
		JOURNAL_PATH=/run/log/journal/
		CURRENT_USE=8388608
		CURRENT_USE_PRETTY=8.0M
		MAX_USE=202133504
		MAX_USE_PRETTY=192.7M
		```

   * `export`
  
		Que crea un flux binari adequat per a còpies de seguretat i transferència
		de la xarxa. Com per exemple nomes exportar on el hostname sigui
		localhost

		```
		$ journalctl -o export _HOSTNAME=localhost.localdomain 
		__CURSOR=s=78aab514ed50497e9d0c225a94bdc38a;i=1;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fcb7;t=53c8f8bcf46f2;x=11b855cd1e8380fe
		__REALTIME_TIMESTAMP=1473962107160306
		__MONOTONIC_TIMESTAMP=2620599
		_BOOT_ID=80d79a0d0fe9408dacc70b62cce3a019
		SYSLOG_FACILITY=3
		SYSLOG_IDENTIFIER=systemd-journald
		_TRANSPORT=driver
		PRIORITY=6
		MESSAGE_ID=ec387f577b844b8fa948f33cad9a75e6
		MESSAGE=Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
		```
   
   * `json`
  
		Que dóna format a les entrades com les estructures de dades JSON. (En l'exemple
		no esta posat tot el codi sencer, per que es massa gran i amb un exemple d'un
		troç de fragment crec que ja es suficient).

		```
		$ journalctl -o json
		{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=1;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fcb7;t=53c8f8bcf46f2;x=11b855cd1e8380fe", "__REALTIME_TIMESTAMP" : "1473962107160306"}
		{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=2;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fd87;t=53c8f8bcf47c3;x=f12832885a850be2", "__REALTIME_TIMESTAMP" : "1473962107160515"}
		{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=3;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fda6;t=53c8f8bcf47e3;x=b167f19b27ebab3f", "__REALTIME_TIMESTAMP" : "1473962107160547"}
		{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=4;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fdbb;t=53c8f8bcf47f8;x=1edbd9a4e3e5e4af", "__REALTIME_TIMESTAMP" : "1473962107160568"}
		{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=5;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fdc9;t=53c8f8bcf4805;x=e103f957f5eddf9a", "__REALTIME_TIMESTAMP" : "1473962107160581"}
		{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=6;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fdd7;t=53c8f8bcf4814;x=865feeaf2456f5a0", "__REALTIME_TIMESTAMP" : "1473962107160596"}
		{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=7;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fde9;t=53c8f8bcf4825;x=abe1ee01d7022929", "__REALTIME_TIMESTAMP" : "1473962107160613"}
		```
  
  * `json-pretty`
		Entrades de dades JSON, però en formats de múltiples 
		línies per tal que siguin més llegibles pels humans.

		```
		$ journalctl -o json-pretty 
		{
		"__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=1;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fcb7;t=53c8f8bcf46f2;x=11b855cd1e8380fe",
		"__REALTIME_TIMESTAMP" : "1473962107160306",
		"__MONOTONIC_TIMESTAMP" : "2620599",
		"_BOOT_ID" : "80d79a0d0fe9408dacc70b62cce3a019",
		"SYSLOG_FACILITY" : "3",
		"SYSLOG_IDENTIFIER" : "systemd-journald",
		"SYSLOG_IDENTIFIER" : "systemd-journald",
		"_TRANSPORT" : "driver",
		"PRIORITY" : "6",
		"MESSAGE_ID" : "ec387f577b844b8fa948f33cad9a75e6",
		"MESSAGE" : "Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.",
		"JOURNAL_NAME" : "Runtime journal",
		"JOURNAL_PATH" : "/run/log/journal/",
		"CURRENT_USE" : "8388608",
		"CURRENT_USE_PRETTY" : "8.0M",
		"MAX_USE" : "202133504",
		"MAX_USE_PRETTY" : "192.7M",
		"DISK_KEEP_FREE" : "303202304",
		"DISK_KEEP_FREE_PRETTY" : "289.1M",
		"DISK_AVAILABLE" : "2012909568",
		"DISK_AVAILABLE_PRETTY" : "1.8G",
		"LIMIT" : "202133504",
		"LIMIT_PRETTY" : "192.7M",
		"AVAILABLE" : "193744896",
		"AVAILABLE_PRETTY" : "184.7M",
		"_PID" : "158",
		"_UID" : "0",
		"_GID" : "0",
		"_COMM" : "systemd-journal",
		"_EXE" : "/usr/lib/systemd/systemd-journald",
		"_CMDLINE" : "/usr/lib/systemd/systemd-journald",
		"_CAP_EFFECTIVE" : "25402800cf",
		"_SYSTEMD_CGROUP" : "/system.slice/systemd-journald.service",
		"_SYSTEMD_UNIT" : "systemd-journald.service",
		"_SYSTEMD_SLICE" : "system.slice",
		"_MACHINE_ID" : "53778091e2364a30a5a98d40c2d7fe56",
		"_HOSTNAME" : "localhost.localdomain"
		}
		```
  
  * `json-sse`
  
		Entrades de dades JSON, però envoltades en un format adequat per
		esdeveniments enviats pel servidor. (En l'exemple
		no esta posat tot el codi sencer, per que es massa gran i amb un exemple d'un
		troç de fragment crec que ja es suficient).
		
		```
		$ journalctl -o json-sse
		data: { "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=1;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fcb7;t=53c8f8bcf46f2;x=11b855cd1e8380fe" "__REALT...}

		data: { "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=2;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fd87;t=53c8f8bcf47c3;x=f12832885a850be2", "__REALT...}

		data: { "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=3;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fda6;t=53c8f8bcf47e3;x=b167f19b27ebab3f", "__REALT...}

		data: { "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=4;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fdbb;t=53c8f8bcf47f8;x=1edbd9a4e3e5e4af", "__REALT...}
		```

  * `cat`
  
		Genera una sortida molt concisa, només es mostra el missatge real de 
		cada entrada del journal sense metadades, ni tan sols una marca de temps.
		
		```
		$ journalctl -o cat
		Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
		microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
		Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
		Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe249 ro rhgb quiet LANG=es_ES.UTF-8
		x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
		x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
		x86/fpu: Enabled xstate features 0x3, context size is 576 bytes, using 'standard' format
		```

  * `short`
  
		Mostra identicament lo mateix que cridar `journalctl` sense 
		parametres.
		
		```
		$ journalctl -o short
		-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:11:44 CEST. --
		sep 15 19:55:07 localhost.localdomain systemd-journald[158]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
		sep 15 19:55:07 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
		sep 15 19:55:07 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
		sep 15 19:55:07 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe249 ro rhgb quiet LANG=es_ES.UTF-8
		sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
		sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
		sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Enabled xstate features 0x3, context size is 576 bytes, using 'standard' format.
		```

  * `short-iso`
  
		Es molt similar pero mostrant les marques de temps en el format
		**ISO 8601**
		
		```
		$ journalctl -o short-iso 
		-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:11:44 CEST. --
		2016-09-15T19:55:07+0200 localhost.localdomain systemd-journald[158]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
		2016-09-15T19:55:07+0200 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
		2016-09-15T19:55:07+0200 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
		2016-09-15T19:55:07+0200 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe249 ro rhgb quiet LANG=es_ES.UTF-8
		2016-09-15T19:55:07+0200 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
		2016-09-15T19:55:07+0200 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
		2016-09-15T19:55:07+0200 localhost.localdomain kernel: x86/fpu: Enabled xstate features 0x3, context size is 576 bytes, using 'standard' format.
		2016-09-15T19:55:07+0200 localhost.localdomain kernel: x86/fpu: Using 'eager' FPU context switches.
		```

  * `short-precise`
  
		Es molt similar, però mostra les marques de temps amb una precisió de 
		microsegons completa.
		
		```
		$ journalctl -o short-precise 
		-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:11:44 CEST. --
		sep 15 19:55:07.160306 localhost.localdomain systemd-journald[158]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
		sep 15 19:55:07.160515 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
		sep 15 19:55:07.160547 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
		sep 15 19:55:07.160568 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe249 ro rhgb quiet LANG=es_ES.UTF-8
		sep 15 19:55:07.160581 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
		sep 15 19:55:07.160596 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
		sep 15 19:55:07.160613 localhost.localdomain kernel: x86/fpu: Enabled xstate features 0x3, context size is 576 bytes, using 'standard' format.
		sep 15 19:55:07.160638 localhost.localdomain kernel: x86/fpu: Using 'eager' FPU context switches.
		```

* `journalctl -r`

Ens permet mostrar la sortida en ordre invers, els primers a sota, 
i els últims a sobre.

```
$ journalctl -r
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:11:44 CEST. --
abr 25 20:11:44 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:11:44 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:08:58 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:08:56 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:08:55 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:08:54 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
```

* `journalctl -f`

Emula el clàssic `tail -f`. Aquesta ordre ens permet veure les entrades
en temps reals, vol dir que en el moment que es processin noves entrades,
automaticament les veurem a sota ja que es queda en **_background_** i
consumeix tota l'entrada standard

```
$ journalctl -f
-- Logs begin at jue 2016-09-15 19:55:07 CEST. --
abr 25 20:08:54 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:08:54 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:08:54 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
ARA SORTIRA NOU AL FER UN START DEL SERVEI HTTPD
abr 25 20:14:59 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac77c0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:15:00 localhost.localdomain dbus-daemon[596]: [system] Activating via systemd: service name='net.reactivated.Fprint' unit='fprintd.service'
abr 25 20:15:00 localhost.localdomain audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=fprintd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
abr 25 20:15:00 localhost.localdomain systemd[1]: Starting Fingerprint Authentication Daemon...
```

* `journalctl -u servei.service`

Amb aquest parametre, podem veure els logs generats d'un servei
especific com per exemple el del servei `httpd`

```
$ journalctl -u httpd.service
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:16:21 CEST. --
oct 13 20:24:44 localhost.localdomain systemd[1]: Starting The Apache HTTP Server...
oct 13 20:24:44 localhost.localdomain httpd[8822]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using localhost.localdomain. Set the 'ServerName' directive globally to suppress this message
oct 13 20:24:44 localhost.localdomain systemd[1]: Started The Apache HTTP Server.
oct 13 20:38:02 localhost.localdomain systemd[1]: Started The Apache HTTP Server.
oct 13 20:43:40 localhost.localdomain systemd[1]: Stopping The Apache HTTP Server...
oct 13 20:43:41 localhost.localdomain systemd[1]: Stopped The Apache HTTP Server.
```

* `journalctl -k`

Una altra forma de veure informació és veure els missatges que ens proporciona
el **kernel** i gracies al parametre `-k` es possible observar-los.

```
$ journalctl -k
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:16:21 CEST. --
abr 25 19:41:38 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
abr 25 19:41:38 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
abr 25 19:41:38 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe249 ro
abr 25 19:41:38 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
abr 25 19:41:38 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
abr 25 19:41:38 localhost.localdomain kernel: x86/fpu: Enabled xstate features 0x3, context size is 576 bytes, using 'standard' format.
abr 25 19:41:38 localhost.localdomain kernel: x86/fpu: Using 'eager' FPU context switches.
```

* `journalctl --disk-usage`

Parametre molt util per el tema de **quotes**, ja que amb aquest parametre
podem sapiguer quant ocupen els registres de `journald`.

```
$ journalctl --disk-usage
Archived and active journals take up 3.9G on disk.
```

Comprobem que ens ocupa **3.9G** en el disc.

* `journalctl --vacum-size=`
Amb l'altre parametre hem vist que podem sapiguer quant ens ocupa en disc
els registres de journald, doncs amb `--vacum-size` podem eliminar espai
i retenir per exemple com a maxim 1.5G.

```
$ journalctl --vacuum-size=1.5G
Deleted archived journal /var/log/journal/0dd3a45452b340e3bece923b3eab00ec/system@49bcec464fa749b48d64ac9350ed5a71-0000000000000001-00053c87046aa4c2.journal (72.0M).
Deleted archived journal /var/log/journal/0dd3a45452b340e3bece923b3eab00ec/user-202190@242b978f1090476ab350467551edacb9-000000000000150a-00053c8759bd5b0b.journal (24.0M).
```

No poso tota la sortida ja que es massa extensa.

Una vegada fet, tornem a comprobar quant ens ocupa ara els registres
de journald.

```
$ journalctl --disk-usage
Archived and active journals take up 1.7G on disk.
```

Comprovem que ha baixat bastant comparat amb abans.

* `journalctl --vacum-time=`

Té la mateixa finalitat que `--vacum-size` pero en aquest cas, podem
eliminar espai i retenir per exemple els registres de __l'ultim mes__.

```
$ journalctl --vacuum-time="1 months"
Deleted archived journal /var/log/journal/0dd3a45452b340e3bece923b3eab00ec/system@fb325ac2f8a94f57a074211c7cd4590e-0000000000243090-00054b4dba74528a.journal (128.0M).
Deleted archived journal /var/log/journal/0dd3a45452b340e3bece923b3eab00ec/system@fb325ac2f8a94f57a074211c7cd4590e-000000000027122f-00054b4dceb938da.journal (128.0M).
```

No poso tota la sortida ja que es massa extensa.

A part de per **mes** podem especificar per:

* `s` segons
* `min` minuts
* `h` hora
* `days` dies
* `weeks` setmanes
* `suffixes` suffixos dels anys

Una vegada fet, tornem a comprobar quant ens ocupa ara els registres
de journald.

```
$ journalctl --disk-usage
Archived and active journals take up 480.1M on disk.
```

I de nou hem comprovat que ha baixat bastant comparat amb abans.

* `journalctl /dev/sda`

No sàvia que podem mirar els logs de /dev/sda i la veritat és que ho 
veig molt útil per si tenim algun problema en algun dels nostres discos.

```
$ journalctl /dev/sda
-- Logs begin at Thu 2016-09-15 09:44:47 CEST, end at Fri 2017-05-05 12:46:53 CEST. --
May 05 09:02:09 localhost.localdomain kernel: pci 0000:00:17.0: [8086:a102] type 00 class 0x010601
May 05 09:02:09 localhost.localdomain kernel: pci 0000:00:17.0: reg 0x10: [mem 0xdf228000-0xdf229fff]
May 05 09:02:09 localhost.localdomain kernel: pci 0000:00:17.0: reg 0x14: [mem 0xdf22c000-0xdf22c0ff]
May 05 09:02:09 localhost.localdomain kernel: pci 0000:00:17.0: reg 0x24: [mem 0xdf22b000-0xdf22b7ff]
May 05 09:02:09 localhost.localdomain kernel: ahci 0000:00:17.0: AHCI 0001.0301 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
May 05 09:02:09 localhost.localdomain kernel: ahci 0000:00:17.0: flags: 64bit ncq sntf pm led clo only pio slum part ems deso sadm sds apst 
May 05 09:02:09 localhost.localdomain kernel: scsi host3: ahci
May 05 09:02:09 localhost.localdomain kernel: scsi 3:0:0:0: Direct-Access     ATA      KINGSTON SHFS37A BBF0 PQ: 0 ANSI: 5
```
