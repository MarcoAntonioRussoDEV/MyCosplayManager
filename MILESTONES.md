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
- [ ] **Progetti cosplay + calcolatore prezzo** — entita' Progetto (nome/foto/descrizione) con prodotti collegati; calcolo costo per prodotto (o range di categoria) + manodopera (€/h).
- [ ] **Monetizzazione** — ADS, funzionalita' premium (limiti free/premium, rimozione ADS).

## Note

- Versioning: bump solo a release, non ad ogni commit — vedi testata di [CHANGELOG.md](CHANGELOG.md).
- Piano originale (contesto/decisioni di stack) in `C:\Users\Ocrama94\.claude\plans\wise-sleeping-gray.md`.
