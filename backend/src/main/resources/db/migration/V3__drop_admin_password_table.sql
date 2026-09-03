-- L'accesso alla dashboard admin e' passato a Google OAuth con whitelist di email
-- (config, non DB): la tabella admins con password locale non serve piu'.
DROP TABLE admins;
