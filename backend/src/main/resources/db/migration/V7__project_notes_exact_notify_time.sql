-- Sostituisce "scadenza + preavviso in giorni" con un istante preciso (data+ora+minuto) in
-- cui inviare la notifica, scelto direttamente dall'utente (piu' semplice da testare e da
-- capire: niente piu' calcolo scadenza-preavviso).
ALTER TABLE project_notes ADD COLUMN notify_at TIMESTAMPTZ;
UPDATE project_notes SET notify_at = due_date::timestamptz - (notify_days_before || ' days')::interval;
ALTER TABLE project_notes ALTER COLUMN notify_at SET NOT NULL;

ALTER TABLE project_notes ADD COLUMN notified BOOLEAN NOT NULL DEFAULT false;
UPDATE project_notes SET notified = true WHERE last_notified_date IS NOT NULL;

DROP INDEX IF EXISTS idx_project_notes_due_date;
ALTER TABLE project_notes DROP COLUMN due_date;
ALTER TABLE project_notes DROP COLUMN notify_days_before;
ALTER TABLE project_notes DROP COLUMN last_notified_date;

CREATE INDEX idx_project_notes_notify_at ON project_notes(notify_at) WHERE NOT done AND NOT notified;
