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
- schemaVersion actuelle = 5 (ne pas modifier sans migration — v5 = ajout table RendezVous)
- Toujours exécuter build_runner après modif Drift
- Supabase ne doit jamais bloquer l'UI
- Toujours utiliser toTitleCase() (depuis text_utils.dart) pour les champs nom/prenom/specialite avant enregistrement en base.

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

### [SUITE] — Normalisation de la casse
Création de `lib/utils/text_utils.dart` avec `toTitleCase` et `toSentenceCase`.
Application de `toTitleCase` dans `clients_screen.dart` et `coiffeurs_screen.dart` avant l'enregistrement.
Application de `toSentenceCase` pour les notes dans `payment_screen.dart`.

### [RENDEZ-VOUS] — Onglet Rendez-vous
Migration Drift v5 : ajout de la table `RendezVous` (id, clientId, coiffeurId, dateRdv, typeCoupe, statut, note, dateCreation).
Création de `lib/providers/rendez_vous_provider.dart` avec `vueRdvProvider`, `dateSelectionneeProvider`, `rendezVousProvider`, `rdvAujourdhuilProvider`.
Création de `lib/ui/screens/rendez_vous/rendez_vous_screen.dart` (3 vues : Liste, Jour, Semaine).
Création de `lib/ui/screens/rendez_vous/nouveau_rdv_screen.dart` (Dialog formulaire avec recherche client, date/heure, coiffeur, type coupe).
Modification de `payment_screen.dart` : section "Lier à un rendez-vous existant" qui pré-remplit les champs et marque le RDV 'honore' après paiement.
Modification de `main_layout.dart` : onglet Rendez-vous (index 2), badge rouge dynamique.
Modification de `sync_service.dart` : `syncRendezVous` + intégration dans `syncAll`.
Script SQL Supabase : voir RESUME_PROJET.md section 7.