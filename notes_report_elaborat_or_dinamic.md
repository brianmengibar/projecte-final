### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
------------------------------------------------------

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
que per defecte es el que escolta ``cockpit``
```
https://192.168.2.40:9090/
```

