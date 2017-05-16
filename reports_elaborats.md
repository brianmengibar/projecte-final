### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
----------------------------------------------
<!--
# TODO EL TEMA DE PODER FILTRAR DE (--SINCE, --UNTIL, PRIORITY), MOVERLO DE JOURNAL A ESTE!
-->

# Reports elaborats

Com hem parlat abans, al executar `journalctl` sense paràmetres,
dona una informació massa extensa, per tant, es pot utilitzar diversos
mètodes de filtrat per extreure la informació per satisfer les nostres
necessitats. 

A continuació, mostro les opcions per les quals es poden filtrar:

* Per prioritat
* Per temps
* Per prioritat i temps
* Per filtrat avançat
* Per boot

## Per prioritat

* `journalctl -p prioritat`

	Cal substituir la paraula _prioritat_ amb una de les següents paraules 
	clau (o amb un nombre): 
	
  * debug --> **7**
  * info --> **6**
  * notice --> **5**
  * warning --> **4**
  * err --> **3**
  * crit --> **2**
  * alert --> **1**
  * emerg --> **0**

	```
	journalctl -p crit
	-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:01:03 CEST. --
	sep 15 20:20:13 localhost.localdomain gnome-session-binary[1124]: GLib-GObject-CRITICAL: g_object_unref: assertion 'G_IS_OBJECT (object)' failed
	sep 15 20:20:13 localhost.localdomain gnome-session-binary[1124]: GLib-GObject-CRITICAL: g_object_unref: assertion 'G_IS_OBJECT (object)' failed
	sep 15 20:20:13 localhost.localdomain gnome-session-binary[1124]: GLib-GObject-CRITICAL: g_object_unref: assertion 'G_IS_OBJECT (object)' failed
	```

	O si no també podem escriure `--priority=N` on substituïm **N** per un
	nombre

	```
	journalctl --priority=4
	-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:06:58 CEST. --
	sep 15 19:55:07 localhost.localdomain kernel: ACPI: RSDP 0x00000000000FE020 000024 (v02 HPQOEM)
	sep 15 19:55:07 localhost.localdomain kernel: ACPI: XSDT 0x00000000B9FF6120 000064 (v01 HPQOEM SLIC-MPC 00000001      01000013)
	sep 15 19:55:07 localhost.localdomain kernel: ACPI: FACP 0x00000000B9FF5000 0000F4 (v04 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
	sep 15 19:55:07 localhost.localdomain kernel: ACPI: DSDT 0x00000000B9FE3000 00DC2D (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
	```

## Per temps

En aquests casos, el filtrat basat en el temps és més útil amb aquests
**paràmetres**:

* `journalctl --since "data hora" --until "data hora"`

	S'utilitza per filtrar la sortida per temps,i mostrar únicament els logs
	de certa data i hora, o un **rang de temps.** Els temps es pot 
	especificar seguint el format: `YYYY-MM-DD HH:MM:SS`. Aquest fragment 
	de temps pot anar acompanyat de:
  * `"--since"` per indicar "des de quina data/hora"
  * `"--until"` per indicar "fins a quina data/hora". 

	Per exemple, podem dir que es mostrin les entrades des del **_4 de març 
	de 2017_** fins al **_2 de abril de 2017_**

	```
	journalctl --since "2017-03-04" --until "2017-04-02"
	-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:12:06 CEST. --
	mar 04 13:10:08 localhost.localdomain systemd-journald[157]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
	mar 04 13:10:08 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
	mar 04 13:10:08 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
	```

	Òbviament, també podem ometre el paràmetre `--since` o `--until`
	com en aquest cas que nomes utilitzo `--since` per mostrar tota la informació
	d'avui des de les **12:59:59**

	```
	journalctl --since "2017-05-01 12:59:59"
	-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:12:51 CEST. --
	may 01 13:00:46 localhost.localdomain kernel: perf: interrupt took too long (3129 > 3128), lowering kernel.perf_event_max_sample_rate to 63000
	may 01 13:01:01 localhost.localdomain CROND[2755]: (root) CMD (run-parts /etc/cron.hourly)
	may 01 13:01:01 localhost.localdomain run-parts[2758]: (/etc/cron.hourly) starting 0anacron
	may 01 13:01:01 localhost.localdomain anacron[2766]: Anacron started on 2017-05-01
	may 01 13:01:01 localhost.localdomain run-parts[2768]: (/etc/cron.hourly) finished 0anacron
	```

## Filtrat per prioritat i temps

Les opcions de filtrat es poden combinar, per exemple podem veure
els missatges que ens donen d'error des de fa **1 mes** que seria així:

```
journalctl -p err --since "1 month ago"
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:15:26 CEST. --
abr 03 14:01:03 localhost.localdomain avahi-daemon[591]: chroot.c: open() failed: No such file or directory
abr 03 14:01:33 localhost.localdomain libvirtd[648]: sql_select option missing
abr 03 14:01:33 localhost.localdomain libvirtd[648]: auxpropfunc error no mechanism available
abr 03 14:01:40 localhost.localdomain libvirtd[648]: no es posible abrir  la ruta '/run/media/brian/BRIAN': No such file or directory
abr 03 14:01:40 localhost.localdomain libvirtd[648]: Falló al iniciar automáticamente el grupo de almacenamiento 'BRIAN': no es posible abrir  la ruta '/run/media/brian/BRIAN': No such file or directory
abr 03 14:01:44 localhost.localdomain setroubleshoot[816]: SELinux is preventing postfix from read access on the lnk_file log. For complete SELinux messages. run sealert -l bb31f7f3-8252-4368-87af-408e0a5946d4
```

## Filtrat Avançat

* `journalctl fieldname=value`

	Ídem al paràmetre `export` que hem vist abans en l'opció `-o`.
	Cal substituir _fieldname_ amb un nom d'un camp (**Per exemple 
	HOSTNAME**) i _value_ amb un valor especific del camp que hem posat, llavors
	com a resultat, nomes es retornaran es línies que coincideixin amb
	aquesta condició.
	
	```
	journalctl _HOSTNAME=localhost.localdomain 
	-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:17:32 CEST. --
	sep 15 19:55:07 localhost.localdomain systemd-journald[158]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
	sep 15 19:55:07 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
	sep 15 19:55:07 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 S
	```

	Podem dir per exemple que es mostrin totes les línies que son del
	**executable** _/usr/bin/passwd_.

	```
	journalctl _EXE=/usr/bin/passwd 
	-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:17:32 CEST. --
	oct 21 19:41:55 localhost.localdomain passwd[2097]: pam_unix(passwd:chauthtok): password changed for julia
	oct 21 19:41:55 localhost.localdomain passwd[2097]: gkr-pam: couldn't update the login keyring password: no old password was entered
	-- Reboot --
	oct 23 11:49:02 localhost.localdomain passwd[2508]: pam_unix(passwd:chauthtok): password changed for anna
	oct 23 12:33:47 localhost.localdomain passwd[3512]: pam_pwquality(passwd:chauthtok): pam_parse: unknown or broken option; nullok
	oct 23 12:33:47 localhost.localdomain passwd[3512]: pam_pwquality(passwd:chauthtok): pam_parse: unknown or broken option; nullok
	```

## Filtrat per boots

En les altres comandes, si si ens fixem, el numero dels missatges la veritat
es que es molt gran, així que explorant m'he donat compte que podem
filtrar per els diferents processos d'arrancada que hagi tingut el nostre
ordinador.

* `journalctl --list-boots`

	Amb aquest paràmetre, podem veure:
  * Un llistat de tots els nombres d'arrencada, es a dir els logs de cada vegada que s'ha arrencat el sistema.
  * Els seus documents d'identitat
  * El timestamp d'inici de l'arrencada i un altre timestamp quan finalitza l'arrencada.
	```
	journalctl --list-boots
	-42 fe907fa8428d4a8ba5c03d7ebf247425 Thu 2016-09-15 09:44:47 CEST—Thu 2016-09-15 10:02:23 CEST
	-41 af599e84c38342f985cabac14f48cb2b Thu 2016-09-15 10:02:55 CEST—Thu 2016-09-15 10:24:21 CEST
	-40 1a8e1ee9945b42368a3878a50cfb2abf Fri 2016-10-21 12:06:03 CEST—Fri 2016-10-21 13:00:21 CEST
	-39 83ae824440d74b5490346f645e5abd89 Wed 2016-10-26 12:13:31 CEST—Wed 2016-10-26 13:00:36 CEST
	-38 a9be61942e204275b22e78b40f6f2dd2 Thu 2016-10-27 08:39:01 CEST—Thu 2016-10-27 09:41:00 CEST
	 -2 0ec93da26186419493da77a9515f4c55 Wed 2017-05-03 09:11:00 CEST—Wed 2017-05-03 13:06:20 CEST
	 -1 8675532f691d4a85bb5ee21713193289 Thu 2017-05-04 08:08:08 CEST—Thu 2017-05-04 13:57:55 CEST
	  0 83e2602aee6947d4ba47d1cf123e57c6 Fri 2017-05-05 09:02:09 CEST—Fri 2017-05-05 11:57:44 CEST
	```

	Com es pot veure, he tallat el resultat però si no, quedaria molt extens

* `journalctl -b`

	Amb aquest paràmetre podem veure les entrades del registre nomes des de
	**l'inici actual**, es a dir, si féssim un `--list-boots` seria el 
	numero 0.
	
	```
	journalctl -b
	-- Logs begin at Thu 2016-09-15 09:44:47 CEST, end at Fri 2017-05-05 12:09:11 CEST. --
	May 05 09:02:09 localhost.localdomain systemd-journald[208]: Runtime journal (/run/log/journal/) is 8.0M, max 796.2M, 788.2M free.
	May 05 09:02:09 localhost.localdomain kernel: Linux version 4.5.5-300.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160510 (Re
	May 05 09:02:09 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.5.5-300.fc24.x86_64 root=UUID=dc3c8a0c-7f04-45aa-be36-55f6ea1cb15d ro
	May 05 09:02:09 localhost.localdomain kernel: x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
	```

	Si per algun cas necessitesim veure algun dels anteriors podem optar
	per dues opcions:
	
  1. Utilitzant un compte regressiva
  
	```
	journalctl -b -2
	-- Logs begin at Thu 2016-09-15 09:44:47 CEST, end at Fri 2017-05-05 12:14:17 CEST. --
	May 03 09:11:00 localhost.localdomain systemd-journald[212]: Runtime journal (/run/log/journal/) is 8.0M, max 796.2M, 788.2M free.
	May 03 09:11:00 localhost.localdomain kernel: Linux version 4.5.5-300.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160510 (Re
	May 03 09:11:00 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.5.5-300.fc24.x86_64 root=UUID=dc3c8a0c-7f04-45aa-be36-55f6ea1cb15d ro
	May 03 09:11:00 localhost.localdomain kernel: x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
	```

	En aquest cas estem dient que ens mostri el de fa 2 dies

  2. Utilitzar el ID del boot que ens va aparèixer al llistar els processos d'arrencada amb `--list-boots`.
  
	```
	journalctl _BOOT_ID=8675532f691d4a85bb5ee21713193289
	-- Logs begin at Thu 2016-09-15 09:44:47 CEST, end at Fri 2017-05-05 12:14:17 CEST. --
	May 04 08:08:08 localhost.localdomain systemd-journald[214]: Runtime journal (/run/log/journal/) is 8.0M, max 796.2M, 788.2M free.
	May 04 08:08:08 localhost.localdomain kernel: Linux version 4.5.5-300.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160510 (Re
	May 04 08:08:08 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.5.5-300.fc24.x86_64 root=UUID=dc3c8a0c-7f04-45aa-be36-55f6ea1cb15d ro
	May 04 08:08:08 localhost.localdomain kernel: x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
	```
	
	Si ens fixem, quan he fet `journalctl --list-boots` el ID del -1
	es el mateix que he fet ara per realitzar l'exemple.
