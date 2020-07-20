+++
authors = ["hypertesto"]
categories = ["articolo", "meta"]
cover = "/images/alternative_disqus_cover.png"
date = 2020-07-19T21:50:00Z
tags = ["disqus", "saas", "self-hosted", "commenti", "privacy"]
title = "10+1 valide alternative a Disqus"

+++
Negli ultimi due anni, ho investito svariate giornate nel testare e sperimentare delle soluzioni alternative a Disqus in quanto quest'ultimo non è proprio quello che definirei un servizio _"privacy friendly"._

Questo articolo è stato scritto in più fasi, perciò qualche informazione potrebbe aver subito delle variazioni. Nel caso potete segnalarmelo qua sotto [👇](#comments-area) lasciando un commento.

Prima di passare alla parte interessante (spero!) dell'articolo, vi elenco un po' di motivi per i quali dovreste considerare di rimuoverlo dal vostro blog e sostituirlo con qualcosa di meno invasivo.

## Le mie 5 Ragioni per non usare Disqus

Questo elenco non vuole essere esaustivo, ma rappresenta il **mio** punto di vista sulla questione:

1. **Spia gli utenti:** questo per me è l'aspetto più grave. Ho investito molto tempo i test e ricerca per essere sicuro di avere dei siti senza cookies ove possibile, e più in generale a norma con il GDPR. Ad onor del vero esistono delle impostazioni per migliorare gli aspetti di privacy, tuttavia non sono il default e comunque non vi garantiscono un bel niente.
2. **Vende i dati dei vostri visitatori (e ne siete complici!):** Disqus non è un'azienda che campa solo sul servizio che offre a siti e blog, ma invece è posseduta dalla _ZetaGlobal_ che sostanzialmente si occupa di marketing, che non fa mistero di vedere i dati. Hanno perfino una [pagina dedicata](http://data.disqus.com/) a tale scopo. Vi riporto uno stralcio della pagina informativa così giusto per darvi un'idea:

> Every 30 days, Disqus collects 1.6 trillion data points across 2 billion monthly unique visits to our audience platform. A single Disqus user cookie can contain over 30,000 data points

1. **Piazza pubblicità sul vostro sito:** di questo fatto sarete sicuramente già a conoscenza... quelle pubblicità con titoli clickbait in fondo agli articoli non le trovate anche voi fuori luogo?!
2. **Rallenta i tempi di caricamento:** non ne siete sicuri? aprite un qualsiasi sito che fa uso di Disqus e verificate. Se invece siete pigri vi potete accontentare di questa prova fatta su un blog che gestivo quando andavo ancora alle superiori (e che non ho ancora sistemato, _mea culpa_)

   ![](/images/schermata-a-2020-07-20-09-03-45.png)  
   _Poteve vedere l'immagine ingrandita cliccando [👉 qui](/images/schermata-a-2020-07-20-09-03-45.png)_

   Notate non solo il tempo impiegato dalle varie risorse, ma anche la quantità di roba che carica; ci sono più richieste al CDN di Disqus che alla pagina stessa!
3. **Non permette commenti anonimi:** da un lato essendo un servizio ancora molto utilizzato molti posseggono già un account Disqus, tuttavia obbligare qualcuno a creare un account  per lasciarvi magari un semplice grazie, è un deterrente. Io stesso tendo a non lasciare commenti se mi devo creare account per farlo; e questo per me  vale anche per siti che usano i commenti di wordpress ad esempio.

Ora che vi ho spaventato abbastanza possiamo passare ad alcune considerazioni sull'utilizzo di soluzioni saas oppure self-hosted ed infine alla mia comparazione dei servizi che ho provato in questi anni.

### Cosa serve (secondo me) ad un sistema di commenti come si deve

Siamo nel 2020, i tempi sono cambiati rispetto al 2007, ovvero l'anno di fondazione di Disqus. Se una volta bastava la semplice possibilità di scrivere un breve commento, ora la discussione può richiedere spazio, formattazione e contenuti eterogenei. La gente si aspetta di poter fare grossomodo le stesse cose che fa sui social.

Infine, cosa di primaria importanza, serve un modo efficace di combattere lo spam che non sia la moderazione manuale di tutti i commenti. Se lo spam comincia ad arrivare, arriva ad orde e diventa ingestibile.

Queste considerazioni unite ad altre presenti tra le righe dei paragrafi precedenti, tradotte e riassunte in punti diventano:

1. **Formattazione avanzata**: dal più semplice grassetto all'inserimento di link o immagini. Il top del sogno per me è avere la possibilità di farlo anche scrivendo in markdown, ma non è un requisito stretto.
2. **Voti ai commenti:** stile reddit, con upvote e downvote. Questo per introdurre anche il punto successivo.
3. **Varie opzioni di ordinamento:** dal più recente al più vecchio e viceversa, e per pertinenza (ovvero in base ai voti ricevuti).
4. **Commenti anonimi:** non voglio obbligare nessuno ad iscriversi ad un sevizio che magari userà una volta nella vita. Meglio impiegare cinque minuti ad esprimere un'opinione piuttosto che impiegarli a riempire form di iscrizione.
5. **Autenticazione tramite SSO:** nel caso uno desideri lasciare un commento dovrebbe poterlo fare autenticandosi con uno dei suoi account social o non delle principali piattaforme come ad esempio Google o Facebook (attenzione: sappiamo che FB e Google non sono dei santi dal punto di vista privacy, ma se c'è la possibilità di lasciare commenti anonimi, l'utente più effettuare una scelta ponderata).
6. **Privacy by design:** punto importantissimo e fondamentale, non voglio assolutamente che i miei (pochissimi) utenti vengano usati come prodotti magari perché qualche servizio viene spacciato per gratuito.

Lato utenza finale questo per me è sufficiente, mentre per quel che riguarda aspetti di integrazione e utilizzo da parte mia, questo è il desiderata:

1. **Possibilità di personalizzazioni al tema:** questo per adattare al meglio i commenti al look and feel della pagina. Non sono un designer, ma...
2. **Dashboard con vista omnicomprensiva dei commenti**: in sostanza tutti i commenti in un posto solo.
3. **Moderazione:** dalla stessa vista deve essere possibile moderare i commenti
4. **Varie opzioni di moderazione:** ad esempio approvazione manuale di commenti che rientrano in determinati criteri (ad esempio se contengono link), oppure approvazione manuale in base allo spam score, e così via.
5. **Esportazione dei commenti in formati di uso comune**: se voglio cambiare mi piacerebbe farlo passando i dati da un servizio all'altro tramite un semplice CSV
6. **Inibizione dei commenti su determinate pagine:** questo si spiega abbastanza da solo, può servire se magari la discussione sfocia nel flame oppure più semplicemente se non desideriamo i commenti su determinate pagine.
7. **Notifiche via mail:** invio di notifiche sia per l'admin del sito che per gli utenti che dovrebbero poter o meno iscriversi al feed dei commenti degli articoli che hanno commentato. O perlomeno se ricevono risposte ai loro commenti.

E anche per quel che riguarda la parte più di "backend" questo è quello che servirebbe a me per usare agevolmente un sistema di commenti.

Aggiungo infine un piccolo extra non indispensabile ma che fa di certo comodo: la moderazione dei commenti direttamente nella pagina che li ospita.

Sicuramente non sono pochi punti ma non sono requisiti troppo esoterici... insomma nel 2020 penso che questo sia il minimo sindacale per un sistema di commenti al passo con i tempi.

### Self-hosted o SaaS?

Questo è un bel quesito. La mia risposta è che non ho una risposta precisa. Dipende un da molti fattori, come ad esempio:

* La quantità di commenti ricevuti
* Le nostre capacita tecniche di installare e mantenere qualcosa per conto nostro
* Quanto ogni soluzione rispecchia le nostre esigenze
* Che grado di interazione di aspetta la nostra utenza
* Quanto la nostra utenza premia lo sforzo di mantenere un sistema dedicato ai commenti che rispecchia i vostri valori

Essendo programmatore e sistemista, le capacità tecniche per installare e mantenere soluzioni self-hosted non mi mancano, anzi, ho parecchi servizi che mantengo da vari anni. Il mondo dei commenti, come quello delle mail, per me rappresentano un'eccezione, poiché sono complessi da mantenere secondo me.

Ecco quindi le considerazioni che mi portano, analogamente alle mail, a preferire soluzioni saas per i commenti piuttosto che soluzioni che mi tengo in casa:

* L'eventuale perdita di dati non ha impatti solo per me, ma anche per gli utenti che hanno utilizzato il servizio. Potrebbe sembrare banale da dire, ma se torno su un sito dove avevo cominciato una conversazione, mi dispiacerebbe non vedere più il mio commento. Questo intrinsecamente è anche un aspetto che riguarda l'immagine e affidabilità che diamo ai nostri utenti.
* Servono delle politiche di backup fatte bene: un sistema di commenti potenzialmente potrebbe anche fare cache di immagini o altro, perciò non si tratta solo di fare uno snapshot di un database e via. Inoltre con che frequenza vengono effettuati? Con che policy di retention?
* I bug e le vulnerabilità esistono e ci saranno sempre anche tra i prodotti più affidabili, perciò occorre arrangiarsi ad applicare aggiornamenti e patch di sicurezza.  
  Questo ci porta ad un aspetto non secondario: qualcosa si potrebbe rompere, rovinandovi un piacevole fine settimana o facendovi passare dei brutti quarti d'ora. Questo vale soprattutto se utilizzate software non ancora del tutto maturi o in forte sviluppo.
* Un server minimale dove tenere in piedi la baracca, costa mediamente 5€ al mese (escludendo free tier tipo Heroku o cose così). Onestamente nel mio caso per 4 commenti in croce non vale la pena. Meglio spendere 5€ al mese per altro, ad esempio una casella mail con tutti i crismi.

Nonostante queste premesse, passiamo subito in rassegna soluzioni self-hosted.  
Spolier: per siti statici come ad esempio questo stesso sito, ci sono soluzioni validissime a 0 effort.

### Soluzioni opensource self-hosted

Cominciamo quindi a vedere la categoria di software con cui di mi sono confrontato maggiormente negli ultimi anni.

I software che ho provato sono:

* Discourse
* Isso
* Commento
* Remark42
* Staticman

Prima di vederli nel dattaglio ad uno ad uno, vi indico quali sono i miei parametri di valutazione.

Prima di tutto, sarebbe ottimo se rispettassero i punti elencati nei paragrafi precedenti, tuttavia, sono conscio che per un prodotto opensource non sono poca cosa,  quindi ai fini di questa comparazione mi focalizzerò su altri aspetti che ritengo importanti, ovvero:

* **Facilità di installazione**: deve essere possibile fare un deploy tramite docker (ormai sei server faccio solo così)
* **Utilizzo minimo di risorse:** che per me equivale a poter girare dignitosamente ìn 512MB di RAM su uno o due core.
* **Detect spam:** o tramite integrazione con strumenti di terze parti oppure facente parte nativamente della soluzione.
* **Attività e community:**  ovvero se il progetto è attivamente mantenuto e se la community ha sufficiente massa per garantire supporto e molteplici test di casi d'uso.
* **Interfaccia pronta all'uso**: ovvero se basta effettuare un embed e siamo operativi oppure occorre scrivere qualche riga di codice per integrarlo nella pagine. Non essendo una cima in grafica, preferisco avere già qualcosa di pronto.
* **Esistono anche come Saas?** Avete tutte le le garanzie di un prodotto open, ma non dovete impiegare il vostro tempo per mettere in piedi e mantenere la soluzione è un grade plus. Oltretutto così viene supportato direttamente lo sviluppo.

Per i più pigri, riassumo subito in una comoda tabella i risultai di questa mia analisi:

| Software | Facile da installare | Poche risorse | Spam detect | Community/Sviluppo attivi | Soluzione pronta all'uso | Saas |
| --- | --- | --- | --- | --- | --- | --- |
| Discourse | ✔ | ✖ | ✔ | ✔ | ✔ | ✔ |
| Isso | ✔ | ✔ | ✔ | ✔ | ✔ | ✖ |
| Commento | ✔ | ✔ | ✔ | ✖ | ✔ | ✔ |
| Remark42 | ✔ | ✔ | ✔ | ✔ | ✔ | ✖ |
| Staticman | ✔ | ✔ | ✔ | ✔ | ✖ | ✔ |

_La tabella è stata compilata in momenti diversi, se notate errori o avete precisazioni, non esitate a segnalarmelo tra i commenti._

#### [Discourse](https://www.discourse.org/)

![](/images/discourse.png)

Questo è sicuramente il più famoso dei software presentati poc'anzi. In realtà non si tratta di un sistema di commenti vero e proprio, ma piuttosto di un forum che permette opzionalmente di effettuare un embed sotto un articolo per permetterne la discussione in loco.

Discourse è mastodontico perciò sognatevi che giri con risorse minimali: vi serviranno almeno 2GB di RAM e anche una CPU adeguata per far funzionare il tutto.

Come già indicato, questo è molto di più di un sistema di commenti, ritentevo però giusto citarlo tra le varie possibilità.

#### [Isso](https://posativ.org/isso/)

![/images/isso.png](https://app.forestry.io/sites/uksyov8ynxkynq/body-media//images/isso.png)

Se avete già cercato in internet alternative a Disqus questo sarà sicuramente stato uno dei primi risultati poichè è anche una delle soluizioni che sono state sviluppate prima.

Tra tutte le soluzioni è sicuramente quella dall'aspetto più spartano, è comunque funzionale.

L'installazione e la configurazione avvengono in pochi semplici passaggi è l'utilizzo di risorse è nei miei parametri di valutazione.

Se volete farvi un'idea di come risulta integrato in una pagina potete dare un'occhiata [qui](https://stanislas.blog/2018/02/my-custom-ghost-theme/).

#### [Commento](https://commento.io/)

![/images/commento.png](https://app.forestry.io/sites/uksyov8ynxkynq/body-media//images/commento.png)

Commento per me è stato amore a prima vista. Leggero, sufficientemente completo a prima vista e una cavolata da installare. Mi è piaciuto così tanto che ho anche contribuito al progetto con una piccola patch.

Ora che ne ho cantato le lodi, devo essere onesto e dire che osservandone lo sviluppo da vicino per più di un anno, questa soluzione al momento non è ottimale per una serie di motivi:

* Lo sviluppo è in mano ad una singola persona e procede a rilento e con lunghi periodi di silenzio
* Ci sono una serie di bug piuttosto importanti (ed impattanti proprio nell'uso che ne fa l'utente finale) che non sono mai stati fixati nostante le segnalazioni siano state fatte da tempo. In alcuni casi ci sono merge request pendenti da mesi con i relativi fix che non sono mai state integrate.
* Non è ancora possibile effettuare commenti anonimi (nonostante tale feature sia molto richiesta e anche dichiarata come in roadmap)

Di tutte le soluzioni presenta la grafica secondo me più pulita, infatti è un vero peccato che perda punti per aspetti puramente di gestione.

Se volete contribuire o mostrargli un po' di amore anche voi, [questa](https://gitlab.com/commento/commento "commento gitlab") è la pagina su GitLab.

Potete anche usufruire della versione SaaS pagando ciò che vi sentite, di tutti i servizi che ho visto è l'unico con questo tipo di pricing.

#### [Remark42](https://github.com/umputun/remark42)

![/images/remark42.png](https://app.forestry.io/sites/uksyov8ynxkynq/body-media//images/remark42.png)

Lo osservo da circa 8 mesi, e secondo me è il progetto più promettente tra quelli che vi ho presentato. È attivamente sviluppato e sicuramente tra i tutti è quello più completo dal punto di vista delle feature.

È possibile commentare in modo anonimo tramite una procedura un po' controintuitiva: selezionare "Anonymous" come opzione per il login (sotto alla voce "other").

Tra le varie soluzioni presenta secondo me l'editor più completo mantenendo comunque una grafica piuttosto pulita anche se migliorabile sotto certi aspetti.

Non esiste ancora una versione SaaS, ma con molta probabilità verrà introdotta in futuro (spero non troppo remoto!). Per ora il miglior modo per supportare il progetto è contributire direttamente al suo svoluppo oppure donare tramite [Patreon](https://www.patreon.com/remark42 "remark42 patreon").

#### [Staticman](https://staticman.net/)

Staticman è una soluzione radicalmente differente dalle precedenti: non necessita di database ed è pensato per essere integrato nel workflow dei generatori di siti statici (il commenti su questo sito funzionano così).

In sostanza staticman non è nient'altro che un sistema che processa in maniera del tutto stateless una richiesta proveniente da una form e la salva in un repo secondo la configurazione indicata.

Vien da se che i dati, risiedendo in un repo pubblico (GitHub o GitLab) godono "a gratis" di un meccanismo di backup attivo. Lo svantaggio invece è che non è una soluzione chiavi in mano, ma necessita di una integrazione fatta da 0 a partire dalla form di invio del commento, fino ad arrivare alla visualizzazione come lista. Questo però garantisce massima libertà dal punto di vista grafico se si hanno abbastanza competenze per farlo da sè (nel mio caso staticman era già integrato nel tema, perciò non ho dovuto fare niente).

Staticman è disponibile anche come Saas offerto gratuitamente dalla community, ma vi consiglio vivamente di provare ad installarlo a mano dato che la versione saas pubblica soffre di problemi relativi al superamento delle soglie di utilizzo imposte da Heroku nel tier free (Heroku è la piattaforma presso la quale è ospitato).

Di staticman avrò modo di parlare approfonditamente in un futuro articolo, perciò se siete interessati fate un passaggio di tanto in tanto o iscrivetevi al feed rss 😉.

### Soluzioni SaaS

E veniamo alle soluzioni puramente saas. In internet ne potete trovare svariate, io ho selezionato quelle che mi sembravano più promettenti e soprattutto con un approccio orientato alla privacy. Queste sono le tre che ho provato:

* Valine
* CommentBox
* ReplyBox
* JustComments
* Hyvor Talk

Prima di analizzarli uno ad uno, vi indico qual è il questo caso il mio framework di valutazione:

* **Aderenza più stretta ai punti indicati nei primi paragrafi:** giacchè si paga, è anche lecito aspettarsi di più
* **Possibilità di personalizzazione:** completa o parziale tramite impostazioni o css.
* **Completezza della dashboard**: sono disponibili e ben implementate tutte le operazioni base di moderazione? Funziona in modo trasversale tra più siti?
* **Tier di utilizzo gratuito**: è possibile utilizzarlo gratuitamente? Se sì con che limitazioni?

Come per la rassegna precedente, eccovi tutto riassunto in tabella:

| Software | Commenti anonimi | SSO | Voti | Moderazione in page | Dashboard | Customizzazione look&feel | Tier di utilizzo gratuito |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Valine | ✔ | ✖ | ✖ | ✖ | ✖ | ✖ | ✔ |
| CommentBox | ✔ | ✖ | ✔ | ✔ | ✔ | ✔ | ✔ |
| ReplyBox | ✖ | ✔ | ✖ | ? | ✔ | ✔ | ✖ |
| JustComments<br>(dismesso) | ✔ | ✔ | ✔ | ✖ | ✔ | ✖ | ✖ |
| Hyvor Talk | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |

_La tabella è stata compilata in momenti diversi, se notate errori o avete precisazioni, non esitate a segnalarmelo tra i commenti._

#### [Valine](https://valine.js.org/en/index.html)

![](/images/valinejs.png)

Premetto che ho pensato parecchio se inserire Valine qui o nella categoria opensource. Il dubbio nasce dal fatto che tecnicamente Valine è un progetto opensource, tuttavia per funzionare si basa sullo stack offerto da Leancloud che ha anche un ottimo tier di utilizzo gratuito a voler essere onesti. Ho quindi prefertito tenerlo come saas.

Rispetto a Staticman è una soluzione chiavi in mano per siti statici, ovvero vi basterà aggiungere poche righe di Javascript nelle vostre pagine, ed avrete già la possibilità di commentare e vedere una lista di commenti con una grafica molto pulita.

Attualmente è supportato solo Leancloud come provider per la parte di storage, ma in roadmap è già pianificato il supporto a FireBase.

Non mi risulta che sia presente una dashboard.

#### [CommentBox](https://commentbox.io/)

![](/images/commentbox.png)

CommentBox è la prima soluzione totalmente saas che vi presento.

Graficamente il display dei commenti è gradevole ed è possibile aggiustare alcuni colori per integrarlo al meglio nelle varie pagine (principalmente se il tema è scuro).  
Parlando sempre di grafica, l'editor inserire i commenti mi è sembrato piuttosto grezzo e non mi piace che non si adatti in larghezza alla pagina.

Le funzionalità ci sono grossomodo tutte: voto ai commenti, ordinamento, ecc..

Il tier di utilizzo gratuito è piuttosto interessante poichè garantisce 100 commenti al mese. Quello che non mi piace è che nel tier gratuito non è possibile moderare in modo granulare i commenti: o si modera tutto o niente.

#### [ReplyBox](https://getreplybox.com/)

![](/images/replybox.png)

ReplyBox è stato recentemente rebrandizzato e sono cambiate in modo sostanziale.

Non è presente un tier di utilizzo gratuito, anche se è disponibilie un periodo di prova di 14 giorni, che forse sono un po' pochi per valutare per bene la soluzione. Il piano base è di 10€/mese, non di certo il più economico.

Il look and feel di base sembra molto una via di mezzo tra i commenti di WordPress e Disqus. Pulito ed elegante.

Non mi risulta che sia disponibile la possibilità di commentare in modo anonimo, tuttavia è possibile configurare ogni aspetto di presentazione dei commenti tramite CSS.

#### [JustComments](https://just-comments.com/)

![](/images/justcomments.png)

JustComments è stata una delle prime soluzioni che ho provato, tra queste presentate qui è quella che si presenta più spartana. Ma comunque funzionale.

È possibile ordinare i commenti e c'è anche la possibilità di votare un commento con una reaction. Idea carina.

Dal momento in cui ho iniziato a scrire l'articolo sono successe un po' di cose, quella che interessa direttamente questo servizio è che [sarà dismesso a fine 2020](https://just-comments.com/blog/2020-03-06-just-comments-is-shutting-down.html).

I suoi sviluppatori comunque nell'[ultimo articolo sul loro blog](https://just-comments.com/blog/2020-03-23-hyvor-talk-alternative-system-supports-justcomments.html), indicano Hyvor Talk come sistema alternativo che supporta anche l'importazione dei commenti da questa piattaforma.

Spoiler: Hyvor Talk l'ho scoperto grazie a loro ed è anche quello che per il momento preferisco.

#### [Hyvor Talk](https://talk.hyvor.com?aff=6531)

![](/images/hyvor_talk_full-1.png)

Ed eccoci all'uiltimo contendente della nostra rassegna. Se avete letto lo spoiler due righe sopra, saprete che per ora questa è la soluzione che preferisco. Vediamo il perchè.

Ha tutte le feature che mi aspetto sia per la parte di frontend che sulla dashboard. Rispetto a molti altri ha un anche un sacco di opzioni di importazione, perciò se venite da Disqus o JustComments, per fare due esempi, site coperti.

Graficamente è un po' più "invadente" rispetto agli altri, ma questo gli da un suo carattere e lo distingue nettamente dalle altre soluzioni. A vederla così mi sembrava molto "giocosa" ma ho fatto varie prove e devo dire che fino ad ora è sempre calzata bene dove l'ho provata.

Le opzioni di personalizzazione sono svariate e vi sarà possibile adattare palette di colori e font praticamente a qualsiasi stile. Su questo ho un piccolo appunto: sul sito sono presenti degli esempi di varianti scure / rosa ma nel pannello di controllo non sono presenti come preset e se si vuole ricreare lo stesso effetto bisogna farlo a mano impostando adeguatamente i vari colori. Ecco, io che sono una zappa in queste cose avrei gradito un'opzione per avere una variante scura prefabbricata.

Infine, sopra i commenti è presente un area (disattivabile) dove è possibile selezionare una reaction. Un gradevole plus per molti blog secondo i miei gusti.

Le opzioni sono davvero molte dai testi mostrati alle modalità di moderazione (ad esempio si possono moderare selettivamente solo i commenti anonimi).

Il tier di utilizzo gratuito funziona a visite, che al momento sono 40,000 al mese ma che ad Agosto diverranno 5,000 visto il successo del servizio (5,000 non sono comunque poche per un blog personale).  Pagando 5€ al mese le visite passano a 100,000 ed sono disponibili funzionalità come moderatori multipli che in altre soluzioni sono garantite da piani ben più costosi.

Se volete maggiori info, posso preparare un articoletto dedicato, fatemelo sapere nei commenti.

### Soluzioni particolari

Come ultimo bit di informazione, volevo citarvi [Utterances](https://utteranc.es/ "Utterances sito ufficiale"), che è particolare perchè sfrutta il sistema di commenti delle issue di GitHub effettuandone l'embed su sito.

![](/images/utterances.png)

Vien da sè che sarà necessario disporre di un account su GitHub per poter commentare, sicuramente potrebbe essere interessante per un certo segmento di pubblico quindi valeva la pena citarlo.

Sono disponibili esattaemente le stesse fauture di GitHub, perciò è possibile aggiungere reactions ma non è possibile effettuare ordinamenti.

Come per staticman, questo sistema è nato per gravitare attorno al mondo dei generatori di siti statici, anche se può tranquillamente essere installato su wordpress o semplici pagine HTML fatte a mano.

### Conclusioni

Queste erano le mie 10+1 alternative a Disqus, ciascuna di esse è valida. Alcune per ora sono più complete di altre. 

Come succede molte volte nel mondo dell'informatica, non c'è una soluzione giusta ed una sbagliata. La cosa importante per me è essere consci che le scelte che spesso facciamo per i nostri blog, hanno un impatto sulla privacy degli utenti, che in fin dei conti è la cosa in assoluto più importante.

Esistono, e vanno assolutamente supportati, servizi che nascono e vengono sviluppati in ottica orienta alla privacy. Pagare qualche euro al mese non è necessariamente una sconfitta per chi sarebbe in grado di metter su una baracca per conto proprio, ma piuttosto una scelta libera fatta per rispetto di un'utenza che, nonostante le ultime norme europee, è sempre stata trattata come merce di scambio.

Personalmente ritengo che allo stato attuale, nonostante la soddisfazione e le conoscienze che vi potete portate a casa hostando una soluzione per conto vostro, sia più conveniente affidarsi a servizi saas onesti che hanno fatto della privacy il motore della propria attività.

**La scelta finale è libera ed è vostra, io spero solo di avervi dato elementi sufficienti per decidere, io per ora mi limito a consigliarvi vivamente** [**Hyvor Talk**](https://talk.hyvor.com?aff=6531)**.**