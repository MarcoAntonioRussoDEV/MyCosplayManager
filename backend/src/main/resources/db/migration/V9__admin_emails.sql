-- Whitelist admin dashboard spostata da env var a tabella: aggiungere un nuovo admin
-- non richiede piu' modificare .env + riavviare il backend, solo un giro in dashboard.
CREATE TABLE admin_emails (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email      VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO admin_emails (email) VALUES ('marcoantoniorusso94@gmail.com');
