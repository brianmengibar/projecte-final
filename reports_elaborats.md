### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
----------------------------------------------

# TODO EL TEMA DE PODER FILTRAR DE AQUI A AQUI (TEMA --SINCE, --UNTIL, ETC), MOVERLO DE JOURNAL A ESTE!

# Reports elaborats
Respecte a reports elaborats, podem trobar moltes de journalctl, ja
que ens retorna l'informació sobre la carrega del sistema o sobre avui
mateix.

* ``journalctl -f``
Emula el clàssic ``"tail -f"``. Aquesta ordre ens permet veure les entrades
en temps reals, vol dir que en el moment que es processin noves entrades,
automaticament les veurem a sota ja que es queda en **_background_** i
consumeix tota l'entrada standard
```
journalctl -f
-- Logs begin at Thu 2016-09-15 09:44:47 CEST. --
May 05 09:30:52 i10 python3[3020]: SELinux is preventing 57656220436F6E74656E74 from open access on the file /home/users/inf/hisx2/isx39441584/.config/user-dirs.dirs.
May 05 09:35:38 i10 systemd[1]: Stopped The Apache HTTP Server.
May 05 09:35:38 i10 audit[1]: SERVICE_STOP pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=httpd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
May 05 09:35:38 i10 systemd[1]: Starting The Apache HTTP Server...
May 05 09:35:38 i10 httpd[3208]: AH00548: NameVirtualHost has no effect and will be removed in the next release /etc/httpd/conf.d/moodle.conf:1
May 05 09:35:39 i10 systemd[1]: Started The Apache HTTP Server.
May 05 09:36:22 i10 systemd[1]: Stopped The Apache HTTP Server.
May 05 09:36:22 i10 audit[1]: SERVICE_STOP pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=httpd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
May 05 09:36:22 i10 polkitd[855]: Unregistered Authentication Agent for unix-process:3253:205261 (system bus name :1.88, object path /org/freedesktop/PolicyKit1/AuthenticationAgent, locale en_US.UTF-8) (disconnected from bus)
```

> Només fico un fragment, ja que si no seria molt llarga la sortida.

* ``journalctl -u servei.service``
Amb aquest parametre, podem veure els logs generats d'un servei
especific com per exemple el del servei ``httpd``

```
journalctl -u httpd.service
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:16:21 CEST. --
oct 13 20:24:44 localhost.localdomain systemd[1]: Starting The Apache HTTP Server...
oct 13 20:24:44 localhost.localdomain httpd[8822]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using localhost.localdomain. Set the 'ServerName' directive globally to suppress this message
oct 13 20:24:44 localhost.localdomain systemd[1]: Started The Apache HTTP Server.
oct 13 20:38:02 localhost.localdomain systemd[1]: Started The Apache HTTP Server.
oct 13 20:43:40 localhost.localdomain systemd[1]: Stopping The Apache HTTP Server...
oct 13 20:43:41 localhost.localdomain systemd[1]: Stopped The Apache HTTP Server.
```

* ``Journalctl -b``
Amb aquesta ordre podem veure les entrades del registre nomes des de
l'inici actual, si reiniciem el sistema només de tant en tant, el parametre ``-b`` 
no reduirà significativament la sortida de ``journalctl.``

```
journalctl -b 
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:08:27 CEST. --
may 01 14:42:48 localhost.localdomain systemd-journald[151]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
may 01 14:42:48 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
may 01 14:42:48 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
may 01 14:42:48 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe249 ro
may 01 14:42:48 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
```
