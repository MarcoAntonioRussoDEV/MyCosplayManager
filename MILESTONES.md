# Milestone

Roadmap del progetto. Dettagli implementativi e fix in [CHANGELOG.md](CHANGELOG.md).

## MVP

- [x] **1. Scaffold + schema + auth** — backend Spring Boot (layered), schema DB iniziale, autenticazione Google OAuth (unico metodo), JWT.
- [x] **2. Product + Inventory core** — catalogo prodotti crowdsourced (scan barcode), inventario CRUD con stati (chiuso/aperto/consumato/scartato), categorie con traduzioni it/en/es/fr.
- [x] **3. Shopping list + notification scheduler** — lista spesa per team, scheduler scadenze con push FCM (log-only finche' Firebase non e' configurato).
- [x] **4. App mobile (Flutter)** — login Google, scan barcode, inventario, lista spesa, impostazioni, i18n. Verificata su dispositivo Android reale.
- [x] **5. Admin dashboard (React, PWA, mobile-first)** — login Google (whitelist email), CRUD utenti/team/prodotti/categorie, statistiche.
- [x] **6. Docker compose end-to-end** — dashboard admin dentro `docker-compose.yml` (build statico + nginx), stack intero avviabile con un solo comando.

## Fase 2 (dopo l'MVP)

- [ ] **Mappa negozi** — segnare su una mappa dove si e' comprato un prodotto e a che prezzo (funzionalita' secondaria dal backlog).
- [x] **Progetti cosplay + calcolatore prezzo (backend + app mobile)** — entita' Progetto con materiali ancorati alla categoria scelta dall'utente (non al prodotto: prodotto/inventory item restano facoltativi, solo per prezzo reale/tracciabilita'), calcolo costo materiali (stima da range categoria se prezzo assente) + manodopera. UI app mobile completa (lista/dettaglio/edit progetto, aggiunta materiale con combobox categoria + nota + selettore prodotto filtrato per categoria). Manca solo l'eventuale UI dashboard (non richiesta finora, opzionale).
- [ ] **Monetizzazione** — ADS, funzionalita' premium (limiti free/premium, rimozione ADS). Struttura societaria/fiscale ancora da definire (P.IVA/SAS) prima di collegare AdMob/Play Console a un payments profile reale.
- [x] **Backend switcher a runtime (app mobile)** — cambio ambiente (locale/LAN/custom) senza rebuild, come Unwaste, raggiungibile anche dalla LoginPage prima del login.
- [x] **Note schedulate per progetto** — todo con data + preavviso notifica configurabile per nota, notifica push a tutto il team (log-only finche' Firebase non e' configurato), checkbox fatto/da fare.

## Note

- Versioning: bump solo a release, non ad ogni commit — vedi testata di [CHANGELOG.md](CHANGELOG.md).
- Piano originale (contesto/decisioni di stack) in `C:\Users\Ocrama94\.claude\plans\wise-sleeping-gray.md`.
