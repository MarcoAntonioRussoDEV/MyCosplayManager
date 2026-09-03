# Project Cosplay Inventory

_nome provvisorio_

## Funzionalità principali

L'applicazione android in questione è uno strumento per creativi e cosplayer per la gestione dell'inventario dei prodotti per la realizzazione dei lavori e una sezione per conservare i propri progetti.
Di seguito sono riportare le funzionalità richieste per l'applicazione:

### Autenticazione

L'applicazione deve prevedere l'autenticazione e la registrazione utente con Google OAuth

### Scansione prodotto

L'applicazione deve permettere la scansione del barcode del prodotto e recuperare dal database il prodotto associato, se questo non è presente nel database deve essere chiesto all'utente di salvare la nuova entry.
I campi del prodotto devono essere, nome, marca, quantità, foto, barcode, data scadenza, giorni scadenza dopo apertura prodotto, posizione in laboratorio, prezzo.

### Alert scadenza prodotto

L'applicazione deve inviare notifiche push al dispositivo avvisando dell'imminente scadenza del prodotto in questione, l'alert deve essere configurabile dall'utente che imposterà quanti giorni prima deve essere avvisato della scadenza dei prodotti.

### Gestire inventario

L'applicazione deve gestire l'inventario dei prodotti salvati, mostrandone la lista, il dettaglio e permettendone la modifica e cancellazione, lo stato del prodotto (es: aperto, chiuso, quantità residua).

### Posizione prodotto in laboratorio

L'applicazione deve permettere di gestire l'ubicazione di ogni prodotto, in modo da sapere esattamente in quale punto del laboratorio si trova

### Lista spesa

L'applicazione deve permettere di impostare un carrello della spesa con i prodotti da acquistare

### Categoria prodotti con range di prezzo

L'applicazione deve impostare la categoria di ogni prodotto per poter raggruppare prodotti simili di marche diverse, questo ci permette di poter impostare un range di prezzo in base a quelli segnalati dagli utenti.

### Multilingua

L'applicazione deve essere nativamente multilingua nelle principali lingue _it, en, es, fr_

## Funzionalità di amministrazione

L'applicazione deve prevedere una dashboard di amministrazione con la gestione di diverse fuznionalità. Accessibile su web sotto autenticazione.

## Funzionalità Secondarie

### Prezzo con indicazione ubicazione negozio (mappa?)

L'applicazione deve permettere tramite una mappa di poter segnare il punto di acquisto di tale materiale con relativo prezzo di acquisto

## Funzionalità Extra

### Progetti

L'applicazione deve prevedere la creazione di un Progetto cosplay con nome, foto e descrizione, al cui interno verranno salvati i prodotti utili alla realizzazione

### Calcolatore prezzo

L'applicazione deve avere un calcolatore prezzo sui Progetti, dove poter impostare il costo di ciascun prodotto (o usare il range della categoria) e il costo di manodopera (€/h)

### Notifiche Push pubblicitarie

L'applicazione deve permettere agli admin di inviare notifiche push arbitrarie (è legale?)

# Monetizzazione

L'applicazione deve prevedere ADS, funzionalità premium

### Barcode Esempio

8025520161019 - Scotch carta

<!-- ---

### Foam alta densità - range 40-42€

- cosplay shop 40€ 1x2 m
- cosplay shop2 42€ 1x2 m

### Foam bassa densità - range 30-32€

- cosplay shop 30€
- cosplay shop2 32€

### Scotch - range 1.5-3€

- amazon 3€
- cinese 1.5€

### pittura - range 1.5-3€

- amazon 3€
- cinese 1.5€

## Armatura fuffa

Foam alta densità - 50€
note: cosplay shop
rif prodotto: 8025520161019 "cosplayfoam super ultra"

pittura
scotch - 0€
ore lavoro: 48h
€ a ora: 0€

prezzo minimo 71.5€ + 240€
prezzo minimo 77€ + 240€
prezzo reale -->
