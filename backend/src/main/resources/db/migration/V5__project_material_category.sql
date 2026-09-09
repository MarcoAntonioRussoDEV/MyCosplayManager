-- La riga materiale di un progetto si ancora ora alla CATEGORIA (scelta esplicitamente
-- dall'utente), non al prodotto: permette di stimare il costo dal range di prezzo della
-- categoria anche quando non si sa ancora quale prodotto preciso si comprera'. Il prodotto
-- (e l'eventuale inventory_item) restano un riferimento facoltativo per il prezzo reale.
ALTER TABLE project_materials ADD COLUMN category_id UUID REFERENCES categories(id);
ALTER TABLE project_materials ADD COLUMN note VARCHAR(500);

UPDATE project_materials pm SET category_id = p.category_id
FROM products p WHERE pm.product_id = p.id;

ALTER TABLE project_materials ALTER COLUMN product_id DROP NOT NULL;
