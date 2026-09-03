# Changelog

Storico delle modifiche a `backend/`, `app_mobile/` e `admin_dashboard/`.

**Convenzione versioning (diversa da Unwaste)**: qui il numero di versione (in
`backend/pom.xml` e, quando esistera', `app_mobile/pubspec.yaml`) NON viene
incrementato a ogni commit. Resta fermo su una `-SNAPSHOT` per tutta la fase
di sviluppo di una release; il bump (rimozione di `-SNAPSHOT`, nuova sezione
qui sotto con data) avviene solo quando si taglia effettivamente una release.
Fino ad allora ogni modifica si accumula in **[Non rilasciato]**.

## [Non rilasciato] — 0.1.0-SNAPSHOT

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
