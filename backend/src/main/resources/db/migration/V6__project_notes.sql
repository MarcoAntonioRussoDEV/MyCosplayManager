-- Note/task schedulate su un progetto (es. "16/09: seconda mano di primer"), con notifica
-- push opzionale con preavviso configurabile per nota (giorni prima della data).
CREATE TABLE project_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    text VARCHAR(500) NOT NULL,
    due_date DATE NOT NULL,
    notify_days_before INT NOT NULL DEFAULT 0,
    done BOOLEAN NOT NULL DEFAULT false,
    last_notified_date DATE,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_project_notes_project ON project_notes(project_id);
CREATE INDEX idx_project_notes_due_date ON project_notes(due_date) WHERE NOT done;
