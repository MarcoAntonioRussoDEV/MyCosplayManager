-- La nota ora distingue due istanti indipendenti: quando va svolto il compito (task_at)
-- e quando arriva il promemoria push (notify_at, gia' esistente) — non necessariamente
-- lo stesso momento (es. compito il 30/09 10:00, notifica la sera prima).
ALTER TABLE project_notes ADD COLUMN task_at TIMESTAMPTZ;
UPDATE project_notes SET task_at = notify_at;
ALTER TABLE project_notes ALTER COLUMN task_at SET NOT NULL;
