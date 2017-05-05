### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
----------------------------------------------

# MOVER: journalctl -b, journalctl -r, journalctl -f, A REPORTS ELABORATS?
# MOVER: journalctl --since? --until? Priority?

# Que es journal?
És un component de ``systemd`` que és responsable de la **visualització i 
gestió d'arxius de registre.** Va ser desenvolupat per fer front als 
problemes relacionats amb l'explotació tradicional. 
Està estrictament integrat amb la resta del sistema, és compatible amb 
diverses tecnologies de registre i gestió d'accés per als arxius de 
registre.

El registre de dades es recull, emmagatzema i processa a través del 
servei ``journald``. Es crea i manté arxius binaris anomenats 
**journalds** sobre la base de la informació de registre que es rep des de:
* El nucli
* A partir dels processos dels usuaris
* Sortida estandard
* Sortida d'error dels serveis del sistema
 
Aquests ``journals`` estan estructurats e indexats, aixo fa que es
proporcioni relativament una rapida busqueda. Les entrades de journals
poden portar un identificador **únic.** El servei ``journald`` recull nombrosos 
camps de metadades per a cada missatge de registre. Els arxius de journal 
reals estan assegurats, i per tant **no es poden editar manualment.**

## Visualització de registres
Bé, per accedir als logs de ``journal`` s'utilitza l'eina ``journalctl``.
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

* ``journalctl``
Per defecte, si utilitzem l'ordre sense arguments, mostra tots els 
continguts del ``journal``, començant amb l'entrada més antiga que va ser guardada.

> Cal dir que per defecte, les entrades més antigues es mostren 
al principi. La sortida és mostrada per la sortida standard i no es veu 
tota l'informacio ja que les línies estan truncades, tot i això podem 
moure'ns amb les tecles del cursor a esquerra i dreta per veure el 
contingut complet. I si volem veure les altres entrades, podem pressionar 
la tecla **d'espai** per desplaçar-nos pantalles senceres cap a munt, i 
cap avall.

```
journalctl
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:01:01 CEST. --
sep 15 19:55:07 localhost.localdomain systemd-journald[158]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
sep 15 19:55:07 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
sep 15 19:55:07 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 2016
sep 15 19:55:07 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe
sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Enabled xstate features 0x3, context size is 576 bytes, using 'standard' format.
```

* ``journalctl -n nombre``
En molts casos, només les últimes entrades al registre journal són 
rellevants. Gracies al parametre ``-n`` podem especificar les ultimes **n**
linies que volem veure.
```
journalctl -n 5
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:01:01 CEST. --
abr 25 20:00:21 localhost.localdomain PackageKit[1169]: search-file transaction /739_aebaedba from uid 1000 finished with success after 246ms
abr 25 20:00:21 localhost.localdomain PackageKit[1169]: search-file transaction /740_ebceaebe from uid 1000 finished with success after 246ms
abr 25 20:01:01 localhost.localdomain CROND[4730]: (root) CMD (run-parts /etc/cron.hourly)
abr 25 20:01:01 localhost.localdomain run-parts[4733]: (/etc/cron.hourly) starting 0anacron
abr 25 20:01:01 localhost.localdomain run-parts[4739]: (/etc/cron.hourly) finished 0anacron
```

* ``journalctl -o option``
L'ordre ``journalctl`` permet controlar la forma de la sortida gracies
al parametre ``-o``, cal substituir ``option`` amb una paraula clau que 
especifiqui una forma desitjada de sortida. Hi ha diverses opcions com:
  * ``verbose`` 
  Que retorna els elements amb tots els camps.
```
  journalctl -o verbose
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

  * ``export``
  Que crea un flux binari adequat per a còpies de seguretat i transferència
  de la xarxa. Com per exemple nomes exportar on el hostname sigui
  localhost
```
  journalctl -o export _HOSTNAME=localhost.localdomain 
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
  
  * ``json``
  Que dóna format a les entrades com les estructures de dades JSON. (En l'exemple
  no esta posat tot el codi sencer, per que es massa gran i amb un exemple d'un
  troç de fragment crec que ja es suficient).
```
  journalctl -o json
{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=1;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fcb7;t=53c8f8bcf46f2;x=11b855cd1e8380fe", "__REALTIME_TIMESTAMP" : "1473962107160306"}
{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=2;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fd87;t=53c8f8bcf47c3;x=f12832885a850be2", "__REALTIME_TIMESTAMP" : "1473962107160515"}
{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=3;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fda6;t=53c8f8bcf47e3;x=b167f19b27ebab3f", "__REALTIME_TIMESTAMP" : "1473962107160547"}
{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=4;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fdbb;t=53c8f8bcf47f8;x=1edbd9a4e3e5e4af", "__REALTIME_TIMESTAMP" : "1473962107160568"}
{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=5;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fdc9;t=53c8f8bcf4805;x=e103f957f5eddf9a", "__REALTIME_TIMESTAMP" : "1473962107160581"}
{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=6;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fdd7;t=53c8f8bcf4814;x=865feeaf2456f5a0", "__REALTIME_TIMESTAMP" : "1473962107160596"}
{ "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=7;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fde9;t=53c8f8bcf4825;x=abe1ee01d7022929", "__REALTIME_TIMESTAMP" : "1473962107160613"}
```
  
  * ``json-pretty``
  Entrades de dades JSON, però en formats de múltiples 
  línies per tal que siguin més llegibles pels humans.
```
  journalctl -o json-pretty 
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
  
  * ``json-sse``
  Entrades de dades JSON, però envoltades en un format adequat per
  esdeveniments enviats pel servidor. (En l'exemple
  no esta posat tot el codi sencer, per que es massa gran i amb un exemple d'un
  troç de fragment crec que ja es suficient).
  
```
  journalctl -o json-sse
data: { "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=1;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fcb7;t=53c8f8bcf46f2;x=11b855cd1e8380fe" "__REALT...}

data: { "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=2;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fd87;t=53c8f8bcf47c3;x=f12832885a850be2", "__REALT...}

data: { "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=3;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fda6;t=53c8f8bcf47e3;x=b167f19b27ebab3f", "__REALT...}

data: { "__CURSOR" : "s=78aab514ed50497e9d0c225a94bdc38a;i=4;b=80d79a0d0fe9408dacc70b62cce3a019;m=27fdbb;t=53c8f8bcf47f8;x=1edbd9a4e3e5e4af", "__REALT...}
```

  * ``cat``
  Genera una sortida molt concisa, només es mostra el missatge real de 
  cada entrada del journal sense metadades, ni tan sols una marca de temps.
```
  journalctl -o cat
Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe249 ro rhgb quiet LANG=es_ES.UTF-8
x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
x86/fpu: Enabled xstate features 0x3, context size is 576 bytes, using 'standard' format
```

  * ``short``
  Mostra identicament lo mateix que cridar ``journalctl`` sense parametres
```
journalctl -o short
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:11:44 CEST. --
sep 15 19:55:07 localhost.localdomain systemd-journald[158]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
sep 15 19:55:07 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
sep 15 19:55:07 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
sep 15 19:55:07 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe249 ro rhgb quiet LANG=es_ES.UTF-8
sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
sep 15 19:55:07 localhost.localdomain kernel: x86/fpu: Enabled xstate features 0x3, context size is 576 bytes, using 'standard' format.
```

  * ``short-iso``
  Es molt similar pero mostrant les marques de temps en el format
  **ISO 8601**
```
  journalctl -o short-iso 
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

  * ``short-precise``
  Es molt similar, però mostra les marques de temps amb una precisió de 
  microsegons completa.
```
  journalctl -o short-precise 
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

* ``journalctl -r``
Ens permet mostrar la sortida en ordre invers, els primers a sota, 
i els últims a sobre.
```
 journalctl -r
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:11:44 CEST. --
abr 25 20:11:44 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:11:44 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:08:58 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:08:56 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:08:55 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
abr 25 20:08:54 localhost.localdomain gnome-terminal-server[1857]: (gnome-terminal-server:1857): Gtk-WARNING **: Allocating size to GtkScrollbar 0x55f017ac75d0 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
```

* ``journalctl -f``
Emula el clàssic ``"tail -f"``. Aquesta ordre ens permet veure les entrades
en temps reals, vol dir que en el moment que es processin noves entrades,
automaticament les veurem a sota ja que es queda en **_background_** i
consumeix tota l'entrada standard
```
journalctl -f
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

* ``journalctl -k``
Una altra forma de veure informació és veure els missatges que ens proporciona
el **kernel** i gracies al parametre ``-k`` es possible observar-los.
```
 journalctl -k
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at mar 2017-04-25 20:16:21 CEST. --
abr 25 19:41:38 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
abr 25 19:41:38 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
abr 25 19:41:38 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.7.3-200.fc24.x86_64 root=UUID=a1692407-20c5-4cf0-b6a1-4eb3a3fbe249 ro
abr 25 19:41:38 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
abr 25 19:41:38 localhost.localdomain kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
abr 25 19:41:38 localhost.localdomain kernel: x86/fpu: Enabled xstate features 0x3, context size is 576 bytes, using 'standard' format.
abr 25 19:41:38 localhost.localdomain kernel: x86/fpu: Using 'eager' FPU context switches.
```

* ``journalctl --disk-usage``
Parametre molt util per el tema de **quotes**, ja que amb aquest parametre
podem sapiguer quant ocupen els registres de ``journald``.
```
journalctl --disk-usage
Archived and active journals take up 3.9G on disk.
```
Comprobem que ens ocupa **3.9G** en el disc.

* ``journalctl --vacum-size=``
Amb l'altre parametre hem vist que podem sapiguer quant ens ocupa en disc
els registres de journald, doncs amb ``--vacum-size`` podem eliminar espai
i retenir per exemple com a maxim 1.5G.
```
journalctl --vacuum-size=1.5G
Deleted archived journal /var/log/journal/0dd3a45452b340e3bece923b3eab00ec/system@49bcec464fa749b48d64ac9350ed5a71-0000000000000001-00053c87046aa4c2.journal (72.0M).
Deleted archived journal /var/log/journal/0dd3a45452b340e3bece923b3eab00ec/user-202190@242b978f1090476ab350467551edacb9-000000000000150a-00053c8759bd5b0b.journal (24.0M).
```

> No poso tota la sortida ja que es massa extensa.

Una vegada fet, tornem a comprobar quant ens ocupa ara els registres
de journald.
```
journalctl --disk-usage
Archived and active journals take up 1.7G on disk.
```

Comprovem que ha baixat bastant comparat amb abans.

* ``journalctl --vacum-time=``
Té la mateixa finalitat que ``--vacum-size`` pero en aquest cas, podem
eliminar espai i retenir per exemple els registres de __l'ultim mes__.
```
journalctl --vacuum-time="1 months"
Deleted archived journal /var/log/journal/0dd3a45452b340e3bece923b3eab00ec/system@fb325ac2f8a94f57a074211c7cd4590e-0000000000243090-00054b4dba74528a.journal (128.0M).
Deleted archived journal /var/log/journal/0dd3a45452b340e3bece923b3eab00ec/system@fb325ac2f8a94f57a074211c7cd4590e-000000000027122f-00054b4dceb938da.journal (128.0M).
```

A part de per **mes** podem especificar per:
* ``s`` segons
* ``min`` minuts
* ``h`` hora
* ``days`` dies
* ``months`` mesos
* ``weeks`` setmanes
* ``suffixes`` suffixos dels anys

> No poso tota la sortida ja que es massa extensa.

Una vegada fet, tornem a comprobar quant ens ocupa ara els registres
de journald.

```
journalctl --disk-usage
Archived and active journals take up 480.1M on disk.
```

I de nou hem comprovat que ha baixat bastant comparat amb abans.

## El filtrat de missatges

Com hem parlat abans, el executar ``journalctl`` sense parametres,
dona una informació massa extensa, per tant, es pot utilitzar diversos
metodes de filtrat per extreure informació per satisfer les nostres
necessitats. A continuació, es mostren les opcions per les quals es poden
filtrar per i despres desplegarem cadascuna per sapiguer com fer-ho:

* Per prioritat
* Per temps
* Per prioritat i temps
* Per filtrat avançat

### Per prioritat
* ``journalctl -p prioritat``
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

O si no tambe podem escriure ``--priority=N```on substituim **N** per un
nombre

```
journalctl --priority=4
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:06:58 CEST. --
sep 15 19:55:07 localhost.localdomain kernel: ACPI: RSDP 0x00000000000FE020 000024 (v02 HPQOEM)
sep 15 19:55:07 localhost.localdomain kernel: ACPI: XSDT 0x00000000B9FF6120 000064 (v01 HPQOEM SLIC-MPC 00000001      01000013)
sep 15 19:55:07 localhost.localdomain kernel: ACPI: FACP 0x00000000B9FF5000 0000F4 (v04 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
sep 15 19:55:07 localhost.localdomain kernel: ACPI: DSDT 0x00000000B9FE3000 00DC2D (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
```

### Per temps
En aquests casos, el filtrat basat en el temps és més útil amb aquests
**parametres**:

* ``journalctl --since "data hora" --until "data hora"``
S'utilitza per filtrar la sortida per temps,i mostrar únicament els logs
de certa data i hora, o un **rang de temps.** Els temps es pot 
especificar seguint el format: ``YYYY-MM-DD HH:MM:SS``. Aquest fragment 
de temps pot anar acompanyat de:
  * ``"--since"`` per indicar "des de quina data/hora"
  * ``"--until"`` per indicar "fins a quina data/hora". 

Per exemple, podem dir que es mostrin les entrades des del **_4 de març 
de 2017_** fins al **_2 de abril de 2017_**

```
journalctl --since "2017-03-04" --until "2017-04-02"
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:12:06 CEST. --
mar 04 13:10:08 localhost.localdomain systemd-journald[157]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
mar 04 13:10:08 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
mar 04 13:10:08 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 SMP Wed Sep 7 17:31:21 UTC 2016
```

Obviament, tambe podem ometre el parametre ``--since`` o ``--until``
com en aquest cas que nomes utilitzo ``--since`` per mostrar tota l'informació
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
els missatges que ens donen d'error des de fa **1 mes** que seria aixi:
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
``journalctl fieldname=value``
Idem al parametre ``export`` que hem vist abans en l'opció ``-o``.
Cal substituir _fieldname_ amb un nom d'un camp (**Per exemple 
HOSTNAME**) i _value_ amb un valor especific del camp que hem posat, llavors
com a resultat, nomes es retornaran es linies que coincideixin amb
aquesta condició.
```
journalctl _HOSTNAME=localhost.localdomain 
-- Logs begin at jue 2016-09-15 19:55:07 CEST, end at lun 2017-05-01 14:17:32 CEST. --
sep 15 19:55:07 localhost.localdomain systemd-journald[158]: Runtime journal (/run/log/journal/) is 8.0M, max 192.7M, 184.7M free.
sep 15 19:55:07 localhost.localdomain kernel: microcode: microcode updated early to revision 0xa0b, date = 2010-09-28
sep 15 19:55:07 localhost.localdomain kernel: Linux version 4.7.3-200.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160621 (Red Hat 6.1.1-3) (GCC) ) #1 S
```

Podem dir per exemple que es mostrin totes les linies que son del
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

## Filtrar per boots
En les altres comandes, si si ens fixem, el numero dels missatges la veritat
es que es molt gran, aixi que explorant m'he donat compte que podem
filtrar per els diferents processos d'arrancada que hagi tingut el nostre
ordinador.

* ``journalctl --list-boots``
Amb aquest parametre, podem veure:
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

> Com es pot veure, he tallat el resultat pero si no, quedaria molt extens


* ``journalctl -b``
Amb aquest parametre podem veure les entrades del registre nomes des de
**l'inici actual**, es a dir, si fessim un ``--list-boots`` seria el 
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
   * Utilitzant un compte regressiva
```
journalctl -b -2
-- Logs begin at Thu 2016-09-15 09:44:47 CEST, end at Fri 2017-05-05 12:14:17 CEST. --
May 03 09:11:00 localhost.localdomain systemd-journald[212]: Runtime journal (/run/log/journal/) is 8.0M, max 796.2M, 788.2M free.
May 03 09:11:00 localhost.localdomain kernel: Linux version 4.5.5-300.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160510 (Re
May 03 09:11:00 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.5.5-300.fc24.x86_64 root=UUID=dc3c8a0c-7f04-45aa-be36-55f6ea1cb15d ro
May 03 09:11:00 localhost.localdomain kernel: x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
```
  
  > En aquest cas estem dient que ens mostri el de fa 2 dies

   * Utilitzar el ID del boot que ens va apareixer al llistar els processos
  d'arrencada amb ``--list-boots``.
```
journalctl _BOOT_ID=8675532f691d4a85bb5ee21713193289
-- Logs begin at Thu 2016-09-15 09:44:47 CEST, end at Fri 2017-05-05 12:14:17 CEST. --
May 04 08:08:08 localhost.localdomain systemd-journald[214]: Runtime journal (/run/log/journal/) is 8.0M, max 796.2M, 788.2M free.
May 04 08:08:08 localhost.localdomain kernel: Linux version 4.5.5-300.fc24.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.1.1 20160510 (Re
May 04 08:08:08 localhost.localdomain kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.5.5-300.fc24.x86_64 root=UUID=dc3c8a0c-7f04-45aa-be36-55f6ea1cb15d ro
May 04 08:08:08 localhost.localdomain kernel: x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
```
  > Si ens fixem, quan he fet ``journalctl --list-boots`` el ID del -1
    es el mateix que he fet ara per realitzar l'exemple.
