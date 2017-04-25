**Nom: Brian Mengibar Garcia**

**Identificador: isx39441584**

**Curs: HISX2**

**Projecte: _Serveis informatius de Systemd_**
----------------------------------------------

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

**Visualització de registres**

Be, per accedir als logs de ``journal`` s'utilitza l'eina ``journalctl``.
Que mostra journalctl? Doncs una llista de tots els fitxers de registre
generats en el sistema, incloent missatges generats pel sistema o per els
propis usuaris.

**Que ens proporcionen aquests fitxers?**

* Línies de prioritat més alta d'error i es destaquen en color **vermell** 
i amb una font en **negreta**, s'utilitza per a línies amb notificació i
prioritat d'alerta.
* Les marques de temps es converteixen per a la zona horària local del nostre sistema.
* El començament d'una arrencada de sistema esta marcat amb una línia diferent

**Parametres de journalctl**

A continuació es mostraran una serie de parametres que conte l'ordre
``journalctl``:

* ``journalctl``
Per defecte, si utilitzem l'ordre sense arguments, mostra tots els 
continguts del ``journal``, començant amb l'entrada més antiga que va ser guardada.

**OJO**: Cal dir que per defecte, les entrades més antigues es mostren 
al principi. La sortida és mostrada per la sortida standard i no es veu 
tota l'informacio ja que les línies estan truncades, tot i això podem 
moure'ns amb les tecles del cursor a esquerra i dreta per veure el 
contingut complet. I si volem veure les altres entrades, podem pressionar 
la tecla **d'espai** per desplaçar-nos pantalles senceres cap a munt, i cap avall.



* ``journalctl -n numero``
En molts casos, només les últimes entrades al registre journal són 
rellevants. Gracies al parametre ``-n`` podem especificar les ultimes **n**
linies que volem veure.



* ``journalctl -o option``
L'ordre ``journalctl`` permet controlar la forma de la sortida gracies
al parametre ``-o``, cal substituir ``option`` amb una paraula clau que 
especifiqui una forma desitjada de sortida. Hi ha diverses opcions com:
  * ``verbose`` 
  Que retorna els elements amb tots els camps.
  

  
  * ``export``
  Que crea un flux binari adequat per a còpies de seguretat i transferència
  de la xarxa. Com per exemple nomes exportar on el hostname sigui
  localhost
  

  
  * ``json``
  Que dóna format a les entrades com les estructures de dades JSON. 
  

  
  * ``json-pretty``
  Entrades de dades JSON, però en formats de múltiples 
  línies per tal que siguin més llegibles pels humans.
  

  
  * ``json-sse``
  Entrades de dades JSON, però envoltades en un format adequat per
  esdeveniments enviats pel servidor.
  

  
  * ``cat``
  Genera una sortida molt concisa, només es mostra el missatge real de 
  cada entrada del journal sense metadades, ni tan sols una marca de temps.
  

  
  * ``short``
  Mostra identicament lo mateix que cridar ``journalctl`` sense parametres
  

  
  * ``short-iso``
  Es molt similar pero mostrant les marques de temps en el format
  **ISO 8601**
  

  
  * ``short-precise``
  Es molt similar, però mostra les marques de temps amb una precisió de 
  microsegons completa.
  


* ``journalctl -r``
Ens permet mostrar la sortida en ordre invers, els primers a sota, 
i els últims a sobre.



* ``journalctl -f``
Emula el clàssic ``"tail -f"``. Aquesta ordre ens permet veure les entrades
en temps reals, vol dir que en el moment que es processin noves entrades,
automaticament les veurem a sota ja que es queda en **_background_** i
consumeix tota l'entrada standard



* ``journalctl -u servei.service``
Amb aquest parametre, podem veure els logs generats d'un servei
especific com per exemple el del servei ``httpd``


* ``systemctl -t service -a``
S'utilitza per llistar tots els serveis que tenim en el sistema, gracies
al parametre ``-a``, es mostren tots els serveis, ja estiguin actius o
inactius, si treiesim el parametre ``-a``, nomes es veurien els serveis
que estan actius.



* ``journalctl -k``
Una altra forma de veure informació és veure els missatges que ens proporciona
el **kernel** i gracies al parametre ``-k`` es possible observar-los.



**El filtrat de missatges**

Com hem parlat abans, el executar ``journalctl`` sense parametres,
dona una informació massa extensa, per tant, es pot utilitzar diversos
metodes de filtrat per extreure informació per satisfer les nostres
necessitats. A continuació, es mostren les opcions per les quals es poden
filtrar per i despres desplegarem cadascuna per sapiguer com fer-ho:

* Per prioritat
* Per temps
* Per prioritat i temps
* Per filtrat avançat

  **Per prioritat**
  
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
   

   
   O si no tambe podem escriure ``PRIORITY=N```on substituim **N** per un
   numero
   

   
   O escriure despres del parametre ``-p`` la paraula clau
   


  **Per temps**
  
  * ``systemctl -b``
  Amb aquesta ordre podem veure les entrades del registre nomes des de
  l'inici actual

 

  Si reiniciem el sistema només de tant en tant, el parametre ``-b`` 
  no reduirà significativament la sortida de ``journalctl.``
  En aquests casos, el filtrat basat en el temps és més útil amb aquests
  **parametres**:
  
  * ``journalctl --since "data hora" --until "data hora"``
  S'utilitza per filtrar la sortida per temps,i mostrar únicament els logs
  de certa data i hora, o un **rang de temps.**

  Els temps es poden especificar seguint el format: ``YYYY-MM-DD HH:MM:SS``.
  D'altra banda, aquest fragment de temps pot anar acompanyat d'un ``"--since"``
  per indicar "des de quina data/hora", o un ``"--until"`` per indicar "fins a quina
  data/hora".

  Per exemple, podem dir que es mostrin les entrades des del **_4 de març de
  2017_** fins al **_2 de abril de 2017_**



  Obviament, tambe podem ometre el parametre ``--since`` o ``--until``
  com en aquest cas que nomes utilizem ``--since`` i en un format
  mes llegible per els humans dient que ens mostrin les entrades del mes
  anterior.



  **Filtrat per prioritat i temps**
  
  Les opcions de filtrat es poden combinar, per exemple podem veure
  els missatges que ens donen d'error des de fa **1 mes** que seria aixi:
  ``journalctl -p error --sice "1 month ago"``
  
  
  **Filtrat Avançat**
  
  ``journalctl fieldname=value``
  Idem al parametre ``export`` que hem vist abans en l'opció ``-o``.
  Cal substituir _fieldname_ amb un nom d'un camp (**Per exemple 
  HOSTNAME**) i _value_ amb un valor especific del camp que hem posat, llavors
  com a resultat, nomes es retornaran es linies que coincideixin amb
  aquesta condició.
  
  Podem dir per exemple que es mostrin totes les linies que son del
  **executable** _/usr/bin/passwd_ que seria aixi:
  ``journalctl _EXE=/usr/bin/passwd``.
  
