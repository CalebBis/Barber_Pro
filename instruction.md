# INSTRUCTION.MD — BENJI COIFFURE

## PRÉSENTATION DU PROJET
Application desktop Flutter Windows de gestion d'un salon 
de coiffure. Gère les clients, paiements, coiffeurs, 
inventaire et paramètres. Synchronisée avec Supabase.
Voir RESUME_PROJET.md pour l'architecture complète.

## RÈGLES ACTIVES
- Lire RESUME_PROJET.md et instruction.md avant tout
- Pas de couleurs hardcodées dans les écrans
- Couleur boutons via ref.watch(buttonColorProvider)
- schemaVersion actuelle = 4 (ne pas modifier sans migration)
- Toujours exécuter build_runner après modif Drift
- Supabase ne doit jamais bloquer l'UI

## HISTORIQUE DES MODIFICATIONS

### [INITIAL] — Mise en place du projet
Projet initialisé avec Flutter Desktop, Drift SQLite,
Supabase, Riverpod, fl_chart, pdf/printing.
6 onglets créés : Dashboard, Paiement, Clients, 
Coiffeurs, Inventaire, Paramètres.
Système de fidélité implémenté (1 gratuite / 4 payantes).
Migration Drift v4 avec table Parametres.
Couleur des boutons personnalisable via color_provider.dart.
Thème clair/sombre fonctionnel sur tous les onglets.
Synchronisation Supabase implémentée dans sync_service.dart.