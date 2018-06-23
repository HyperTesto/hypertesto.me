---
title: "Tracciamento delle visite GDPR friendly"
date: 2018-06-20T22:28:19+02:00
draft: false
categories:
  - articolo
tags:
  - gdpr
  - statistiche
  - fathom
---

Come annunciato nel mio [precedente articolo](/blog/gdpr-checklist), in ottemperanza alla nuova normativa europea sulla privacy, ho deciso di rimuovere dai miei siti tutti i servizi Google, Disqus e qualsiasi altro servizio che installa cookie di profilazione a tradimento. 

Alle integazioni social ho rinunciato completamente poichè non mi interessano granchè, tuttavia vorrei avere un minimo di traccia del numero di visite ai vari articoli. 

Girovagando su internet, ho trovato del materiale ([1][1], [2][2]) molto utile per inquadrare meglio la spinosa questione dell'anonimizzazione dati personali, nel caso specifico delle statistiche raccolti tramite cookie. 
In internet troverete tonnellate di articoli su come fare con Google Analytics, ma il ragionamento vale per qualsiasi servizio stiate utilizzando.

## Cosa mi interessa tracciare

I dati che voglio tracciare sono i seguenti:

* numero di visite per pagina
* numero di visite univoche per pagina

Inoltre, vorrei anche avere un modo di fruire i dati raccolti tramite una dashboard minimale (possibilimente con login).

## Fathom to the resque

Con un po' di ricerca mi sono inbattuto in Fathom, un progetto open-source che, rispetta i requisiti che mi sono fissato.

Vi riporto direttamente l'introduzione tratta dal [sito ufficiale](https://usefathom.com/) che secondo me centra in pieno il problema:

>
>Collecting information on the internet is important, but it’s broken. We’ve become complacent in trading information for free access to web services, and then complaining when those web services do crappy things with that data. (Hey Zuck, how was Congress?)
>
>The problem is this: if we aren’t paying for the product, we are the product.
>
>Current analytics platforms, like Google Analytics, give you free access to their services but in turn, they’re assembling data profiles on your website visitors, which they can then use for better targeting of advertisements across their network.
>
>We need to stop giving away our data and our users privacy for free >access to a tool.
>
>

Per il momento il servizio è solo self-hosted, comunque installazione e configurazione sono davvero semplici (ho scritto una piccola [guida](/blog/installare-fathom-su-ubuntu-16.04) a riguardo) ed inoltre non occupa molte risorse (probabilmente gira senza problemi anche su un raspberry). 

La dashboard è davvero molto semplice e c'è anche la possibilità di filtrare per data!

![fathom](/images/fathom.png)

Pur utilizzandolo solo da pochi giorni devo dire che sono davvero soddisfatto (sorvolando su qualche piccolissimo bug) e mi sento di consigliarlo.







[1]: http://blog.decaro.la/2018/02/13/gdpr-google-analytics-adactio/  "GDPR e Google Analytics"
[2]: https://spreadprivacy.com/data-anonymization/ "Data Anonymization"


