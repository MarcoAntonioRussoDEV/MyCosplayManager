CREATE TABLE projects (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id               UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    name                  VARCHAR(255) NOT NULL,
    description           TEXT,
    image_url             TEXT,
    labor_hours           NUMERIC(10, 2),
    labor_rate_per_hour   NUMERIC(10, 2),
    created_by            UUID NOT NULL REFERENCES users(id),
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_projects_team_id ON projects(team_id);

-- Tabella ponte verso il catalogo prodotti (non verso un singolo inventory_item: lo
-- stesso rotolo di foam/tubetto di colla puo' essere usato a pezzi su piu' progetti).
-- Quantita' e prezzo sono uno snapshot al momento in cui il materiale viene aggiunto,
-- non un puntatore live: il costo di un progetto non deve muoversi da solo se dopo si
-- modifica/consuma/elimina l'articolo in inventario.
CREATE TABLE project_materials (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id          UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    product_id          UUID NOT NULL REFERENCES products(id),
    -- Riferimento facoltativo, solo per tracciabilita' ("questo materiale viene da
    -- quell'acquisto li'"): se l'item viene cancellato il materiale del progetto resta.
    inventory_item_id   UUID REFERENCES inventory_items(id) ON DELETE SET NULL,
    quantity            NUMERIC(10, 2) NOT NULL,
    unit                VARCHAR(32) NOT NULL,
    price               NUMERIC(10, 2),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_project_materials_project_id ON project_materials(project_id);
