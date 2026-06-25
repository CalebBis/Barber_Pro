-- ============================================
-- SCHEMA SUPABASE POUR BENJI COIFFURE
-- A executer dans l'editeur SQL de Supabase
-- ============================================

-- Table clients
CREATE TABLE IF NOT EXISTS clients (
  id BIGINT PRIMARY KEY,
  nom TEXT NOT NULL,
  prenom TEXT NOT NULL,
  telephone TEXT,
  notes TEXT,
  total_coupes INTEGER NOT NULL DEFAULT 0,
  gratuites_disponibles INTEGER NOT NULL DEFAULT 0,
  date_creation TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Table coiffeurs
CREATE TABLE IF NOT EXISTS coiffeurs (
  id BIGINT PRIMARY KEY,
  nom TEXT NOT NULL,
  prenom TEXT NOT NULL,
  specialite TEXT,
  actif BOOLEAN NOT NULL DEFAULT true,
  photo_path TEXT,
  nationalite TEXT,
  lieu_naissance TEXT,
  date_naissance TIMESTAMPTZ
);

-- Table visites
CREATE TABLE IF NOT EXISTS visites (
  id BIGINT PRIMARY KEY,
  client_id BIGINT NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  coiffeur_id BIGINT NOT NULL REFERENCES coiffeurs(id) ON DELETE CASCADE,
  date_visite TIMESTAMPTZ NOT NULL DEFAULT now(),
  type_coupe TEXT NOT NULL,
  montant INTEGER NOT NULL,
  est_gratuite BOOLEAN NOT NULL DEFAULT false,
  note TEXT
);

-- Index pour les recherches frequentes
CREATE INDEX IF NOT EXISTS idx_visites_client ON visites(client_id);
CREATE INDEX IF NOT EXISTS idx_visites_coiffeur ON visites(coiffeur_id);
CREATE INDEX IF NOT EXISTS idx_visites_date ON visites(date_visite DESC);

-- Activer RLS (Row Level Security) - requis par Supabase
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE coiffeurs ENABLE ROW LEVEL SECURITY;
ALTER TABLE visites ENABLE ROW LEVEL SECURITY;

-- Politiques RLS - permettre toutes les operations (app desktop interne)
CREATE POLICY "Allow all on clients" ON clients FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on coiffeurs" ON coiffeurs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on visites" ON visites FOR ALL USING (true) WITH CHECK (true);

-- Activer Realtime sur la table visites
ALTER PUBLICATION supabase_realtime ADD TABLE visites;

-- ============================================
-- MIGRATIONS (A executer si les tables existent deja)
-- ============================================

-- Ajout du champ adresse a la table coiffeurs (Migration v3)
ALTER TABLE coiffeurs ADD COLUMN IF NOT EXISTS adresse TEXT;

