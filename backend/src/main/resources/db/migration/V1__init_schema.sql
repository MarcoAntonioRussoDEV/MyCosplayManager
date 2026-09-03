CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE teams (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(255) NOT NULL,
    invite_code VARCHAR(16) NOT NULL UNIQUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE users (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email                       VARCHAR(255) NOT NULL UNIQUE,
    name                        VARCHAR(255) NOT NULL,
    google_id                   VARCHAR(255) NOT NULL UNIQUE,
    team_id                     UUID NOT NULL REFERENCES teams(id),
    notification_days_before   INTEGER NOT NULL DEFAULT 3,
    is_banned                   BOOLEAN NOT NULL DEFAULT false,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_users_team_id ON users(team_id);

CREATE TABLE categories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code        VARCHAR(64) NOT NULL UNIQUE,
    name_it     VARCHAR(255) NOT NULL,
    name_en     VARCHAR(255) NOT NULL,
    name_es     VARCHAR(255) NOT NULL,
    name_fr     VARCHAR(255) NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE products (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    barcode             VARCHAR(64) NOT NULL UNIQUE,
    name                VARCHAR(255) NOT NULL,
    brand               VARCHAR(255),
    category_id         UUID REFERENCES categories(id),
    image_url           TEXT,
    days_after_opening  INTEGER,
    source              VARCHAR(64) NOT NULL DEFAULT 'USER',
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_products_category_id ON products(category_id);

CREATE TABLE inventory_items (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id             UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    product_id          UUID NOT NULL REFERENCES products(id),
    quantity            NUMERIC(10, 2) NOT NULL,
    unit                VARCHAR(32) NOT NULL,
    price               NUMERIC(10, 2),
    location_text       VARCHAR(255),
    expiry_date         DATE,
    status              VARCHAR(16) NOT NULL DEFAULT 'SEALED' CHECK (status IN ('SEALED', 'OPENED', 'CONSUMED', 'DISCARDED')),
    opened_at           DATE,
    remaining_quantity  NUMERIC(10, 2),
    last_notified_date  DATE,
    created_by          UUID NOT NULL REFERENCES users(id),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_inventory_items_team_id ON inventory_items(team_id);
CREATE INDEX idx_inventory_items_status_expiry ON inventory_items(status, expiry_date);
CREATE INDEX idx_inventory_items_product_id ON inventory_items(product_id);

CREATE TABLE shopping_list_items (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id       UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    product_id    UUID REFERENCES products(id),
    custom_name   VARCHAR(255),
    quantity      NUMERIC(10, 2),
    unit          VARCHAR(32),
    is_purchased  BOOLEAN NOT NULL DEFAULT false,
    created_by    UUID NOT NULL REFERENCES users(id),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_shopping_list_items_team_id ON shopping_list_items(team_id);

CREATE TABLE device_tokens (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    fcm_token   VARCHAR(512) NOT NULL UNIQUE,
    platform    VARCHAR(32) NOT NULL DEFAULT 'ANDROID',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_device_tokens_user_id ON device_tokens(user_id);

CREATE TABLE admins (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username       VARCHAR(255) NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);
