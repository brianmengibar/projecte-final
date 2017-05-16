### Nom: Brian Mengibar Garcia

### Identificador: isx39441584

### Curs: HISX2

### Projecte: _Serveis informatius de Systemd_
---------------------------------------------------

# Para corregir en casa faltas: [isx39441584@i10 projecte-final]$ aspell --lang=ca check ARCHIVO

## Introducció

Benvinguts al meu projecte sobre **"Serveis informatius de Systemd"**.

El propòsit d'aquest projecte es:
* Presentar de forma absolutament **exhaustiva** totes les ordres i opcions relacionada amb:
  * **Systemd**
  * **Journalctl**
* Trobar **Ordres visuals**
* Trobar **Reports Elaborats**
* Trobar si existeixen **reports dinàmics**

A continuació podeu veure un breu **index** que conté tots els apartats 
que he realitzat.

### Index

* [Systemd](notes_systemd.md#systemd)
  * [Que es Systemd](notes_systemd.md#que-es-systemd)
  * [Eines de Systemd](notes_eines_systemd.md#systemd-analyze)
* [Journal](notes_journal.md#journal)
  * [Que es journal](notes_journal.md#que-es-journal)
  * [Paràmetres de journal](notes_journal.md#parametres-de-journalctl)
* [Ordres visuals](ordres_visuals.md#ordres-visuals)
  * [Plot](ordres_visuals.md#explorant-plot)
  * [Dot](ordres_visuals.md#explorant-dot)
* [Reports elaborats](reports_elaborats.md#reports-elaborats)
  * [Prioritat](reports_elaborats.md#per-prioritat)
  * [Temps](reports_elaborats.md#per-temps)
  * [Prioritat i temps](reports_elaborats.md#filtrat-per-prioritat-i-temps)
  * [Avançat](reports_elaborats.md#filtrat-avan%C3%A7at)
  * [Boots](reports_elaborats.md#filtrat-per-boots)
* [Reports dinàmics](reports_dinamics.md#reports-dinamics)
  * [Cockpit](reports_dinamics.md#que-%C3%A9s-cockpit)
  * [Systemd Manager](reports_dinamics.md#que-%C3%A9s-systemd-manager)

A continuació, podeu veure un llistat de **links** d'on estic extreien 
tota d'informació per poder realitzar el projecte:

### Links on extreure informació

* Links sobre systemd
  * [Archlinux Systemd](https://wiki.archlinux.org/index.php/systemd_(Espa%C3%B1ol)
  * [Blog Systemd](http://www.rafaelrojas.net/2012/08/24/entendiendo-a-systemd/)
  * [FedoraProject Systemd](https://fedoraproject.org/wiki/Systemd)
  * [F.D.Systemd](https://docs.fedoraproject.org/en-US/Fedora/24/html/System_Administrators_Guide/ch-Services_and_Daemons.html)
  * [Eines systemd](https://diversidadyunpocodetodo.blogspot.com.es/2016/07/systemd-analyze-kcm-systemadm-systemctl.html)

* Links sobre journal
  * [Blog Journalctl](https://juncotic.com/journalctl-comandos-interesantes/)
  * [Journal Documentation](https://docs.fedoraproject.org/en-US/Fedora/24/html/System_Administrators_Guide/s1-Using_the_Journal.html)
  * [ArchWiki Journal](https://wiki.archlinux.org/index.php/Systemd#Journal)
  * [Para rellenar journal o systemd](http://www.elarraydejota.com/guia-tecnica-de-gestion-de-servicios-en-systemd-para-administradores-de-sistemas/)

* Links sobre cockpit
  * [How to Cockpit](https://www.liquidweb.com/kb/how-to-use-cockpit-in-fedora-23/)
  * [Documentation Oficial Cockpit](http://cockpit-project.org/guide/latest/)

* Links sobre systemd-manager
  * [Systemd Manager](https://copr.fedorainfracloud.org/coprs/nunodias/systemd-manager/)

* Altres
  * [Para rellenar journal o systemd](http://www.elarraydejota.com/guia-tecnica-de-gestion-de-servicios-en-systemd-para-administradores-de-sistemas/)
  * [Systemd Manager](https://copr.fedorainfracloud.org/coprs/nunodias/systemd-manager/)
  * [Otros de la familia systemd]( https://wiki.christophchamp.com/index.php?title=Systemd#timedatectl)
  * [Crear un service?](https://www.tecmint.com/create-new-service-units-in-systemd/)
  * [Puede servir](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units)

#Uso_b.C3.A1sico_de_systemctl)
