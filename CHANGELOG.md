# Changelog

Storico delle modifiche a `backend/`, `app_mobile/` e `admin_dashboard/`.

**Convenzione versioning (diversa da Unwaste)**: qui il numero di versione (in
`backend/pom.xml` e, quando esistera', `app_mobile/pubspec.yaml`) NON viene
incrementato a ogni commit. Resta fermo su una `-SNAPSHOT` per tutta la fase
di sviluppo di una release; il bump (rimozione di `-SNAPSHOT`, nuova sezione
qui sotto con data) avviene solo quando si taglia effettivamente una release.
Fino ad allora ogni modifica si accumula in **[Non rilasciato]**.

## [Non rilasciato] — 0.1.0-SNAPSHOT

### Deploy sul server di casa (OcramaHomeServer), HTTPS reale

- Progetto clonato in `~/Projects/MyCosplayManager` sul Raspberry Pi che gia'
  ospita OperazioneFratellino (stesso dominio DDNS `ocrama94.tplinkdns.com`,
  gestito da TP-Link). Nessun conflitto reale con OF: OF usa 80/443, MCM usa
  8080/8081/8443/8444 — entrambi i servizi restano attivi.
- Nuovo servizio `caddy` in `docker-compose.yml` (+ `Caddyfile`): termina TLS
  per backend (`:8443`) e admin dashboard (`:8444`) riusando il certificato
  Let's Encrypt che OF ha gia' emesso per lo stesso dominio (mount read-only
  di `/etc/letsencrypt`) — nessun nuovo certificato da richiedere, nessuna
  sfida ACME su porta 80 (occupata da OF/certbot).
- Postgres non pubblica piu' la porta verso l'host (`5432`) — nessun motivo
  per esporlo fuori dalla rete docker interna, tanto meno su un deploy
  raggiungibile da internet.
- App: preset "Server remoto (ocrama94)" ora punta a
  `https://ocrama94.tplinkdns.com:8443` (era HTTP su :8080) — rimossa anche
  l'eccezione cleartext in `AndroidManifest.xml`/`network_security_config.xml`,
  non piu' necessaria con TLS reale.

### App mobile — preset backend remoto per test fuori rete locale

- Nuovo preset "Server remoto (ocrama94)" nello switcher backend
  (`http://ocrama94.tplinkdns.com:8080`), preselezionato di default quando
  l'app e' ancora sul default compilato (nessuna scelta esplicita salvata) —
  utile per far provare l'app a chi non e' sulla stessa rete locale (es. il
  socio) senza dover digitare un URL custom.
- `network_security_config.xml`: eccezione cleartext (HTTP semplice, non
  HTTPS) solo per `ocrama94.tplinkdns.com` — Android blocca il traffico non
  cifrato di default dalla API 28, altrimenti l'app non si sarebbe nemmeno
  connessa. Va bene per test brevi, non e' un canale cifrato.
- **Bloccanti non risolvibili da qui**, entrambi lato utente: il Windows
  Firewall di questo PC non ha regole inbound per 8080/8081 (default:
  blocca) e il router non sembra inoltrare quelle porte verso questo PC
  (hostname risolve, ma nessuna risposta dall'esterno). Attenzione se si apre
  il port forwarding: NON esporre la porta 5432 (Postgres), solo 8080/8081 —
  il DB usa credenziali deboli (`mycosplaymanager`/`mycosplaymanager`).

### Push notification reali (Firebase Cloud Messaging), finalmente collegate end-to-end

- Motivo: le notifiche erano "solo loggate" fin dalla milestone 3 — il backend
  aveva gia' tutto (`DeviceTokenController`, scheduler), ma l'app non aveva
  MAI integrato `firebase_messaging`, quindi nessun token veniva mai
  registrato e non c'era nessuna credenziale Firebase reale lato backend.
- App Android registrata su Firebase (progetto Firebase gia' esistente
  `cosplayinventory-23b69`, package `com.mycosplaymanager.app`):
  `google-services.json` in `app_mobile/android/app/` (gitignored),
  plugin Gradle `com.google.gms.google-services` applicato
  (`settings.gradle.kts` + `app/build.gradle.kts`), permesso
  `POST_NOTIFICATIONS` in `AndroidManifest.xml`.
- Backend: `firebase-service-account.json` (chiave privata service account,
  generata da Firebase Console) in `secrets/` — gia' montata dal
  `docker-compose.yml` esistente (`FIREBASE_CREDENTIALS_PATH`). Verificato al
  riavvio: log passa da "Firebase non configurato" a "Firebase Cloud
  Messaging inizializzato".
- App: nuovo `core/push_notification_service.dart` — chiede il permesso
  notifiche, ottiene il token FCM, lo registra su `POST /api/device-tokens`
  dopo login/restore sessione, si ri-registra su refresh del token, si
  deregistra su logout. `main.dart` inizializza Firebase prima di `runApp`.
  Build verificata: nessun crash, log conferma
  `FirebaseApp initialization successful`.

### Backend/App mobile — note schedulate per progetto (todo con notifica push)

- Nuova entita' `ProjectNote`: testo libero + istante preciso di notifica
  (`notifyAt`, data+ora+minuto scelti dall'utente, non una scadenza con
  preavviso in giorni — cambio deciso dopo la prima versione, per poter
  testare rapidamente senza aspettare mezzanotte). Migration
  `V6__project_notes.sql` poi `V7__project_notes_exact_notify_time.sql`.
- `GET/POST /api/projects/{id}/notes`, `PUT /api/projects/notes/{noteId}`,
  `PATCH /api/projects/notes/{noteId}/done`, `DELETE /api/projects/notes/{noteId}`.
  Verificato via curl: create, list, toggle done, update (resetta il flag
  notificata), delete.
- `ProjectNoteNotificationScheduler`: notifica **one-shot** (flag `notified`,
  non un dedupe giornaliero come `ExpiryNotificationScheduler`) — parte una
  volta sola al raggiungimento di `notifyAt`, avvisa tutti i membri del team
  del progetto. Cron portato da ogni 5 minuti a ogni minuto
  (`cosplayinventory.notification.scan-cron`, poi rinominato) per la
  precisione al minuto richiesta. Verificato end-to-end: nota schedulata 2
  minuti nel futuro, confermato il flag `notified` scattare al momento giusto.
- App: nuova sezione "Note" nel dettaglio progetto (checkbox fatto/da fare,
  testo barrato se completata, data+ora, tap per modificare — data e ora
  scelte con due picker separati), FAB del dettaglio progetto ora apre un
  menu con due scelte ("Aggiungi materiale" / "Aggiungi nota") invece di
  andare dritto al materiale.
- Fix UX: le etichette dei due picker dicevano "Scadenza"/"Ora" senza mai
  nominare la notifica — sembrava che il campo "data/ora della notifica"
  fosse sparito dopo il redesign a istante esatto. Rinominate in "Data
  notifica"/"Ora notifica" + una riga esplicativa.
- Ripensamento: `notifyAt` non basta, servono DUE istanti indipendenti —
  quando va svolto il compito (`taskAt`) e quando arriva il promemoria push
  (`notifyAt`), non necessariamente lo stesso momento (es. compito il 30/09
  10:00 "gara", notifica la sera prima). Migration
  `V8__project_notes_task_time.sql` (backfill `task_at = notify_at` per le
  note esistenti). App: schermata nota divisa in due sezioni ("Quando va
  fatto" / "Promemoria"), quattro picker indipendenti (data+ora per
  ciascuno). Lo scheduler resta invariato, agisce solo su `notifyAt`.

### Backend/Dashboard admin — notifica push "a comando"

- `POST /api/admin/notifications/send` (titolo+testo liberi, email
  destinatario opzionale — assente = broadcast a tutti i dispositivi
  registrati): per testare la pipeline push senza aspettare uno scheduler.
  Verificato via curl (token admin di dev): broadcast, email inesistente
  (404), email valida.
  Nuova pagina "Notifiche" nella dashboard (form titolo/testo/email).

### Rename: Cosplay Inventory → My Cosplay Manager (nome definitivo)

- Package Java `com.cosplayinventory.backend` → `com.mycosplaymanager.backend`
  (109 file, `git mv` per preservare la history), `groupId` Maven aggiornato.
  Namespace/`applicationId` Android `com.example.app_mobile` →
  `com.mycosplaymanager.app` (richiede un NUOVO client OAuth Android su
  Google Cloud Console, stesso SHA-1 del keystore debug — quello vecchio
  resta registrato per il package precedente, Google Sign-In su Android non
  funziona finche' non se ne crea uno nuovo). Nome pacchetto Dart
  `app_mobile` → `my_cosplay_manager`. Cartella radice del repo rinominata
  (`project_cosplay_inventory` → `my_cosplay_manager`).
- Nome/utente/password del DB Postgres cambiati da `cosplayinventory` a
  `mycosplaymanager` — richiede `docker compose down -v` (volume vecchio
  incompatibile) e reseed dei dati di sviluppo.
  Prefisso delle property Spring (`cosplayinventory.*` negli `@Value` e in
  `application.yml`) rinominato a `mycosplaymanager.*`.
  Titoli/branding aggiornati in app mobile, dashboard admin, `Backlog.md`.
  Lasciati invariati (fatti reali esterni, non rinominabili da codice): l'id
  del progetto Google Cloud (`cosplayinventory`, visibile nei file
  `client_secret_*.json` scaricati dalla console) e i riferimenti storici
  nel CHANGELOG a quell'id.

### Fix critico: autenticazione rotta su TUTTI gli endpoint (mai emerso prima d'ora)

- **Causa**: `JwtAuthenticationFilter` e `AdminJwtAuthenticationFilter` sono
  `@Component`: Spring Boot li auto-registra ANCHE come filtri servlet
  globali (un `FilterRegistrationBean` automatico per ogni bean `Filter`
  trovato), in aggiunta alla copia inserita a mano nella security chain via
  `addFilterBefore(...)`. La copia globale gira fuori dal ciclo di vita del
  `SecurityContextHolderFilter` della chain vera: il `SecurityContext` che
  imposta viene perso prima che il controller lo legga —
  `@AuthenticationPrincipal` arriva sempre `null`, NPE a valle. Bug
  presente fin dal primo commit (nessuno l'ha mai notato perche' nessun
  endpoint autenticato era stato ritestato via curl dopo l'introduzione
  della seconda security chain per l'admin — tutti i test precedenti
  giravano su un'infrastruttura diversa/precedente).
- **Fix**: due `@Bean FilterRegistrationBean<...>` con `setEnabled(false)`
  in `SecurityConfig`, uno per filtro, per disattivare la registrazione
  globale automatica e lasciare solo la copia dentro la security chain.
- **Diagnosi**: niente per tentativi — isolato leggendo lo stack trace con
  `logging.level.org.springframework.security=DEBUG` (mostra la lista
  esatta di filtri per chain), poi confermato con log diretti dentro il
  filtro e dentro il controller (`SecurityContextHolder.getContext()` letto
  nei due punti, prima `Authenticated=true`, un attimo dopo `null` sullo
  stesso thread) — build "baseline" dall'ultimo commit noto buono in un
  git worktree separato per escludere cause ambientali prima di individuare
  la vera causa nel codice.
- Verificata l'intera matrice di isolamento token dopo il fix: token admin
  su endpoint admin (200) e su endpoint utente (401), token utente su
  endpoint utente (200) e su endpoint admin (401) — tutti e quattro corretti.

### Deploy

- Milestone 6: `admin_dashboard` dockerizzata (build multi-stage Node→nginx,
  `admin_dashboard/Dockerfile` + `nginx.conf`) e aggiunta a
  `docker-compose.yml` come servizio `admin` (porta 8081). nginx serve i
  file statici e fa da reverse proxy per `/api/**` verso `backend:8080`
  sulla rete Docker interna (stessa origin per il browser, niente CORS in
  produzione, stesso principio del proxy di Vite in dev). Service
  worker/manifest PWA esclusi dalla cache immutabile. Verificato:
  `docker compose up` avvia tutto lo stack (postgres+backend+admin) con un
  solo comando, index/SPA-fallback/proxy `/api`/manifest tutti risposti
  correttamente, login Google renderizzato su `http://localhost:8081`
  (richiede registrare anche questa origine sul client OAuth Web, stessa
  procedura gia' fatta per `:5173`).

### Backend

- Scaffold Spring Boot (Java 21, layered: `controller/service/repository/entity/dto/security`),
  Postgres + Flyway.
- Schema iniziale (`V1__init_schema.sql`): `teams`, `users`, `categories`,
  `products`, `inventory_items`, `shopping_list_items`, `device_tokens`, `admins`.
- Autenticazione: unico metodo Google OAuth (nessuna password/email), endpoint
  `POST /api/auth/google`, JWT stateless (`JwtService` + `JwtAuthenticationFilter`).
  Ogni nuovo utente riceve un team personale (`TeamService.createPersonalTeam`).
- Fix: `GoogleTokenVerifierService.verify()` non catturava `IllegalArgumentException`
  (lanciata dalla libreria Google per un idToken strutturalmente non valido,
  es. non un JWT) — causava 500 invece del 401 atteso.
- `docker-compose.yml` (postgres + backend) e `Dockerfile` multi-stage,
  verificati end-to-end con `docker compose up`.
- Catalogo prodotti crowdsourced: `GET /api/products/{barcode}` (404 se
  assente), `POST /api/products` (409 se barcode duplicato). Categorie
  (`GET /api/categories`) con traduzioni it/en/es/fr, seed iniziale
  (`V2__seed_categories.sql`) con 8 categorie base per materiali cosplay.
- Inventario per team: CRUD completo (`GET/POST/PUT/DELETE /api/inventory`,
  `PATCH /api/inventory/{id}/status`), filtro per stato, isolamento tra team
  verificato (un team non vede/modifica/cancella gli item di un altro).
- Fix: lettura di un `InventoryItem` fuori dalla propria transazione
  (`open-in-view: false`) lanciava `LazyInitializationException` su
  `product` — aggiunto `JOIN FETCH` nelle query del repository.
- Fix: `changeStatus`/`update` leggevano e salvavano l'item in due
  transazioni separate, cosi' `save()` faceva un `merge()` che riattaccava
  `product` come proxy lazy non inizializzato — i metodi di scrittura del
  service sono ora `@Transactional` end-to-end (lettura+modifica+salvataggio
  nella stessa sessione).
- Lista spesa per team: CRUD (`GET/POST /api/shopping-list`,
  `PATCH .../{id}/purchased`, `DELETE .../{id}`), voci libere (customName)
  o legate a un prodotto del catalogo.
- Registrazione token FCM (`POST/DELETE /api/device-tokens`) e scheduler
  scadenze (`ExpiryNotificationScheduler`, cron ogni 5 minuti): calcola la
  scadenza effettiva (`ExpiryCalculationService`, min tra data stampata e
  apertura+shelf-life prodotto), notifica ogni membro del team sotto la
  propria soglia di preavviso, dedupe giornaliero per articolo. Push solo
  loggate finche' non e' configurato un progetto Firebase reale
  (`FirebaseConfig`, stesso comportamento "log-only" di Unwaste). Verificato
  end-to-end: creato un articolo in scadenza oggi, atteso un ciclo cron
  reale, confermata la notifica simulata nei log.
- `backend/secrets/GenJwt.java` + `dev-seed.sql`: stesso trucco di Unwaste
  per generare un JWT di sviluppo e testare gli endpoint protetti senza un
  client Google OAuth reale configurato (file gitignored, non committati).
- Profilo utente (`GET/PATCH /api/users/me`, per leggere/aggiornare
  `notificationDaysBefore`) e team (`GET /api/teams/me`, `POST /api/teams/join`
  per unirsi a un laboratorio condiviso via invite code).
- Fix: stesso bug di lazy-loading gia' visto sull'inventario, questa volta su
  `TeamController.me()` (`user.getTeam()` letto fuori transazione) — risolto
  con `@Transactional(readOnly = true)`.

### App mobile (Flutter)

- Scaffold Flutter (Android + web), struttura per feature
  (`auth/`, `home/`, `inventory/`, `shopping_list/`, `settings/`, `core/`),
  localizzazione it/en/es/fr generata (`flutter gen-l10n`).
- Login Google (`google_sign_in` + `POST /api/auth/google`), JWT in
  `flutter_secure_storage`, redirect automatico al login su 401.
- Inventario: lista con indicatore visivo di scadenza, scan barcode
  (`mobile_scanner`) con fallback a inserimento manuale, flusso
  "prodotto trovato" vs "crea nuovo prodotto", dettaglio item con azioni
  di cambio stato (apri/consuma/scarta) ed eliminazione.
- Lista spesa: aggiungi/spunta/elimina.
- Impostazioni: giorni di preavviso notifica, cambio lingua (persistito
  in secure storage), codice invito team + join, logout.
- Verificato end-to-end su dispositivo Android reale (non emulatore) via
  `adb reverse tcp:8080 tcp:8080`. Prima passata: schermata di login
  renderizzata, tap su "Accedi con Google" con l'errore atteso
  (`ApiException: 10 / DEVELOPER_ERROR`, nessun client OAuth configurato).
  Creati su Google Cloud Console (progetto `cosplayinventory`) un client
  OAuth Web (audience per `GoogleTokenVerifierService`, passato al backend
  come `GOOGLE_CLIENT_IDS` e all'app come `--dart-define=GOOGLE_SERVER_CLIENT_ID`)
  e uno Android (package `com.example.app_mobile` + SHA-1 del keystore di
  debug, nessun secret — client pubblico). Login Google reale confermato
  funzionante sul dispositivo, e salvataggio di un prodotto/articolo
  verificato anche lato DB (utente reale collegato correttamente alla riga
  utente gia' creata da `dev-seed.sql` via match sull'email, come da logica
  di `AuthController.google()`). Le credenziali OAuth scaricate sono in
  `/secrets` (root, gitignored) con nota su cosa sono.
- Non incluso in questa milestone: integrazione reale Firebase Cloud
  Messaging lato app (richiede un progetto Firebase, il backend e' gia'
  pronto lato `device-tokens`/scheduler), icone/branding definitivi, iOS.
- Rimosso l'inserimento manuale del barcode: lo scan e' sempre disponibile e
  parte automaticamente aprendo "Aggiungi prodotto" (se il barcode non e' a
  catalogo si passa comunque alla scheda "nuovo prodotto"), quindi
  l'alternativa manuale era ridondante.
- **Fix**: un prodotto appena salvato non compariva in Inventario/Lista
  spesa finche' non si rifaceva login. Causa reale (isolata con un logcat
  live durante una prova sul device, non per tentativi): `_reload()` in
  entrambe le pagine usava `setState(() => _future = _repository.list())` —
  la freccia fa si' che il callback ritorni il `Future`
  dell'assegnazione invece di `void`; Flutter lancia
  `setState() callback argument returned a Future` PRIMA di segnare il
  widget da ricostruire. Il fetch partiva comunque (i dati nuovi arrivavano
  davvero dal backend, verificato via log), ma la UI restava agganciata
  alla build precedente finche' un remount completo (logout/login) non
  ripartiva da un `initState()` pulito. Fix: corpo a blocco
  (`setState(() { _future = ...; })`) in entrambi i `_reload()`, che e' poi
  esattamente il pattern che Unwaste usa ovunque per i suoi `_load()`.

### Backend — API admin

- Auth admin separata da quella utente: `POST /api/admin/auth/login` (tabella
  `admins`, bcrypt), JWT distinto (claim `typ=admin`, secret condiviso ma
  mai riusabile sull'altro tipo di endpoint) verificato da una seconda
  `SecurityFilterChain` (`@Order(1)` su `/api/admin/**`, la chain utente
  resta `@Order(2)`). `AdminSeeder` crea il primo account al boot da
  `ADMIN_DEFAULT_USERNAME`/`ADMIN_DEFAULT_PASSWORD` se la tabella e' vuota
  (no-op se gia' popolata o se le env non sono impostate).
- CRUD admin: `GET /api/admin/stats`, `GET/PATCH /api/admin/users` (ban/unban),
  `GET /api/admin/teams` (con conteggio membri), `GET/PUT/DELETE
  /api/admin/products` (delete 409 se ancora in uso in un inventario),
  `GET/POST/PUT/DELETE /api/admin/categories` (delete 409 se ha ancora
  prodotti, create 409 su codice duplicato).
- Verificato via curl: login corretto/errato, isolamento incrociato dei
  token (un token utente su endpoint admin e viceversa, 401 in entrambi i
  casi), ban/unban, creazione/modifica/cancellazione con tutti i controlli
  di conflitto.
- Fix preventivo: stesso pattern di lazy-loading gia' visto altrove,
  applicato subito con query `JOIN FETCH` (`UserRepository.findAllWithTeam`/
  `findWithTeamById`) invece di scoprirlo di nuovo per tentativi.

### Dashboard admin (React + Vite, PWA, mobile-first)

- Scaffold Vite + React 19 + TypeScript, `vite-plugin-pwa` (manifest +
  service worker generati in build). Service worker volutamente minimale:
  precache SOLO l'app shell (JS/CSS/HTML di build), `/api/**` mai
  intercettato ne' messo in cache — stesso principio del service worker
  admin di Unwaste (niente dati amministrativi offline).
  Icone PWA generate con Pillow (`scripts/gen_pwa_icons.py`, stesso spirito
  dello script equivalente in Unwaste).
- UI mobile-first: bottom nav fissa a 5 voci sotto i 768px, sidebar fissa
  da tablet in su (stesso markup, solo CSS). Tabelle: markup `<table>`
  unico che sotto i 640px si trasforma in card impilate (tecnica CSS-only
  via `data-label`), tabella vera da 640px in su. Tema chiaro/scuro via
  `prefers-color-scheme`. Target di tocco minimo 44px ovunque.
- Pagine: Login, Dashboard (stat cards), Utenti (ban/unban), Team (sola
  lettura), Prodotti (modifica/elimina), Categorie (crea/modifica/elimina,
  form in bottom-sheet mobile-first).
- Verificato in browser a viewport mobile (375px, bottom nav + card) e
  desktop (sidebar + tabella), login reale contro il backend via proxy Vite,
  dati letti/scritti confermati end-to-end.
- **Login dashboard passato da username/password a solo Google OAuth**
  (whitelist email via `ADMIN_ALLOWED_EMAILS`, ricontrollata ad ogni
  richiesta dal filtro admin, non solo al login — togliere un'email dalla
  whitelist invalida subito anche i token gia' emessi). Riusa lo stesso
  `GoogleTokenVerifierService` e lo stesso client OAuth "Web" gia' creati
  per l'app mobile: nessun nuovo client da creare su Google Cloud Console.
  Rimossi `Admin` entity/repository/seeder e la tabella `admins`
  (`V3__drop_admin_password_table.sql`) — l'unica fonte di verita' sugli
  admin e' la env var, nessun DB coinvolto. Frontend: pulsante "Accedi con
  Google" via Google Identity Services (script in `index.html`), nessun
  form utente/password. Il bottone si renderizza senza errori anche senza
  configurazione aggiuntiva, ma il sign-in vero fallisce silenziosamente
  finche' non si registra esplicitamente `http://localhost:5173` in
  Authorized JavaScript origins sul client Web (Google Cloud Console →
  Credentials) — non e' auto-permesso come sembrava dal solo rendering.
  Fatto: login Google end-to-end sulla dashboard confermato funzionante.

### Backend — Upload foto e range prezzo categoria

- `POST /api/uploads` (multipart, JPEG/PNG/WebP, riusa il limite 15MB gia'
  configurato): salva su `UPLOAD_DIR` con nome random, torna `{url}`
  relativo. `WebConfig` (`WebMvcConfigurer`) serve quei file sotto
  `/uploads/**` — mancava del tutto, i campi `imageUrl` di prodotti/progetti
  erano finora solo stringhe libere senza un modo reale di caricare un file.
- `GET /api/categories/{id}/price-range` (min/max/avg dai prezzi segnalati
  in `inventory_items`, calcolati al volo): usato dal calcolatore prezzo dei
  Progetti quando un materiale non ha un costo esplicito.

### Backend — Progetti cosplay + calcolatore prezzo

- `projects` (nome/descrizione/foto/ore manodopera/tariffa oraria, scoping
  per team) + `project_materials`, tabella ponte verso il **catalogo
  prodotti** (non verso un `inventory_item` specifico: lo stesso rotolo di
  foam/tubetto di colla puo' essere usato a pezzi su piu' progetti).
  Quantita' e prezzo sono uno snapshot preso al momento in cui il materiale
  viene aggiunto, non un puntatore live all'inventario — il costo di un
  progetto non si muove da solo se dopo si modifica/consuma/elimina quel
  prodotto in inventario. Collegamento a un `inventory_item` supportato ma
  facoltativo, solo per tracciabilita' ("questo materiale viene da
  quell'acquisto li'").
- `GET/POST/PUT/DELETE /api/projects`, `POST/PUT/DELETE
  /api/projects/{id}/materials` (o `/materials/{materialId}`): ogni
  operazione sui materiali torna il progetto ricalcolato
  (`materialsCost` + `laborCost` = `totalCost`). Riga materiale senza
  prezzo esplicito: stimata con la media dei prezzi della categoria del
  prodotto (`GET /api/categories/{id}/price-range`), 0 se la categoria non
  ha ancora dati.
- Verificato end-to-end: materiale con prezzo esplicito, materiale senza
  prezzo (stima da categoria), update prezzo/quantita', rimozione — costo
  totale ricalcolato correttamente ad ogni passo (verificato numericamente,
  non solo "risponde 200").

### Backend/App mobile — aggiungere materiali non presenti in inventario

- `GET /api/products/search?q=` (match case-insensitive su nome o marca, max
  20 risultati): prima l'unico modo di aggiungere un materiale a un progetto
  era scegliere un prodotto gia' presente nell'inventario del team, il che
  escludeva materiali comprati per il progetto ma mai tracciati li'. Ora
  l'app ha due modalita' ("Dall'inventario" / "Cerca prodotto") nella stessa
  schermata di aggiunta materiale.
- Le **categorie restano la fonte della stima prezzo** (`GET
  /api/categories/{id}/price-range`, gia' esistente): l'idea di sostituirle
  con un min/max fisso impostato a mano dall'admin sulla categoria e' stata
  scartata — il range deve restare auto-calcolato dai prezzi reali segnalati
  in inventario per quella categoria, non un valore statico.
- Cambio di responsabilita': la categoria di un prodotto crowdsourced non e'
  piu' scelta dall'utente in fase di creazione (tolto il dropdown categoria
  dal form "nuovo prodotto" dopo scan), ma solo dall'admin via `PUT
  /api/admin/products/{id}` (dashboard, gia' esistente) — l'obiettivo e'
  spogliare il prodotto da nome/marca e ricondurlo alla sua "essenza"
  (es. "Foam alta densita'" vs "Foam bassa densita'", ciascuna con un range
  di prezzo diverso), cosa che l'utente non e' nella posizione di giudicare
  correttamente al momento dello scan.
- Fix: `_ProjectDetailPageState._load()` usava `setState(() =>
  _future = ...)` — stesso bug arrow-Future gia' visto altrove nell'app,
  il rebuild non partiva mai dopo un salvataggio.

### Backend/App mobile — riga materiale ancorata alla categoria, non al prodotto

- Ripensamento dopo la sezione commentata di `Backlog.md` (esempio "Foam alta
  densita' - range 40-42€" / "Armatura fuffa: Foam alta densita' - 50€, nota
  'cosplay shop', rif prodotto opzionale"): una riga materiale di un progetto
  ora si ancora a una **categoria** (obbligatoria, scelta dall'utente), non
  al prodotto. Prodotto/inventory item restano facoltativi, solo per il
  prezzo reale e la tracciabilita' — se assenti, il costo di quella riga
  resta stimato dal range di prezzo della categoria (identico calcolo
  gia' esistente, solo spostato da `product.category` a `material.category`,
  quindi funziona anche per prodotti crowdsourced mai categorizzati
  dall'admin). Aggiunta anche una nota libera per riga (es. "cosplay shop",
  "cinese").
- Migration `V5__project_material_category.sql`: nuova colonna
  `project_materials.category_id` (backfillata dalla categoria del prodotto
  dove presente), nuova colonna `note`, `product_id` reso opzionale.
- `AddProjectMaterialRequest`/`UpdateProjectMaterialRequest`: `categoryId`
  obbligatorio, `productId` ora facoltativo, aggiunto `note`.
- `GET /api/products/search` accetta ora anche `categoryId` opzionale, per
  proporre solo prodotti della categoria scelta. Fix: con `q` assente la
  query JPQL falliva con `function lower(bytea) does not exist` (Postgres
  non riesce a dedurre il tipo di un parametro null passato dentro
  `LOWER()`/`CONCAT()`) — risolto con `CAST(:query AS string)` esplicito.
- App: schermata "Aggiungi materiale" riscritta — combobox categoria (con
  hint range prezzo), nota libera, poi un selettore prodotto facoltativo che
  elenca sia gli articoli del proprio inventario sia risultati di ricerca
  nel catalogo globale, entrambi filtrati per la categoria scelta.
- Verificato via curl: riga senza prodotto/prezzo (stima da categoria, 0 se
  la categoria non ha ancora dati), riga con prodotto+prezzo esplicito,
  ricerca prodotti filtrata per categoria (vuota finche' l'admin non
  categorizza almeno un prodotto in quella categoria, poi la trova).
- Fix: stesso bug arrow-Future in altri due punti di
  `project_detail_page.dart` (`_addMaterial`/`_removeMaterial` — 
  `setState(() => _future = Future.value(detail))`), lista materiali/costo
  non si aggiornava dopo aggiunta/rimozione senza uscire e rientrare dal
  progetto.

### App mobile — cambio backend a runtime (come Unwaste)

- `apiBaseUrl` non e' piu' una `const` da build, ma una variabile che
  `AuthService` puo' sovrascrivere a runtime e persiste in secure storage —
  permette di cambiare rapidamente ambiente (locale via `adb reverse`, LAN,
  URL custom) senza ricompilare, esattamente come `test_backend_page.dart`
  di Unwaste. Il cambio forza il logout (il token del vecchio backend non e'
  valido sul nuovo, utenti/team diversi tra ambienti).
- Nuova voce "Backend (dev)" in Impostazioni, visibile solo con
  `--dart-define=ENABLE_TEST_BACKEND_SWITCHER=true` (le build senza questo
  flag non hanno l'interruttore, stesso principio di Unwaste).
- Interruttore raggiungibile anche dalla `LoginPage` (bottone testuale sotto
  "Accedi con Google"): va cambiato PRIMA di autenticarsi, non solo da
  Impostazioni (a cui si arriva solo da loggati) — stesso posizionamento di
  `test_backend_page.dart` in Unwaste.
