# RÉSUMÉ DU PROJET : BENJI COIFFURE (BARBER PRO)

Ce fichier a pour but de documenter l'état actuel du projet pour permettre à un autre agent IA (ou développeur) de reprendre le travail sans casser l'architecture existante.

## 1. STACK TECHNIQUE
- **Framework** : Flutter Desktop (Cible Windows principalement).
- **Base de données locale (Primaire)** : SQLite géré via le package `drift`.
- **Base de données Cloud (Secondaire / Sauvegarde)** : PostgreSQL géré via `supabase_flutter`.
- **State Management** : `flutter_riverpod` (AsyncNotifier et FutureProvider).
- **Génération PDF** : Packages `pdf` et `printing`.
- **Graphiques** : `fl_chart`.

## 2. ARCHITECTURE DES DONNÉES (Drift / SQLite)
L'application fonctionne en mode **Offline-first**. La source de vérité est la base SQLite locale.
Il y a 5 tables principales (`lib/data/tables.dart`) :
- **Clients** : `id`, `nom`, `prenom`, `telephone`, `notes`, `total_coupes`, `gratuites_disponibles`, `date_creation`.
- **Coiffeurs** : `id`, `nom`, `prenom`, `specialite`, `actif`, `photo_path`, `nationalite`, `lieu_naissance`, `date_naissance`, `adresse`.
- **Visites (Transactions)** : `id`, `client_id`, `coiffeur_id`, `date_visite`, `type_coupe`, `montant`, `est_gratuite`, `note`.
- **Parametres** : `id`, `motDePasse`, `nomSalon`, `themeClair`. Cette table a une seule ligne (ID: 1) et n'est pas (encore) synchronisée sur Supabase.
- **RendezVous** : `id`, `client_id`, `coiffeur_id`, `date_rdv`, `type_coupe`, `statut` (en_attente/honore/annule), `note`, `date_creation`. Migration Drift v5.

## 3. LOGIQUE DE SYNCHRONISATION (Supabase)
Le fichier `lib/services/sync_service.dart` gère la synchronisation vers Supabase.
- **Règle d'or** : Ne **jamais** bloquer l'UI si Supabase est lent ou inaccessible. Tout est dans des `try/catch`.
- **Méthode d'insertion** : Utilisation exclusive de `.upsert()` pour éviter les erreurs de doublons de clés primaires.
- **Déclenchement** : La synchronisation se fait de manière silencieuse dans les "Providers" (`clients_provider.dart`, `coiffeurs_provider.dart`, `visites_provider.dart`) juste **après** que les données ont été sauvegardées avec succès dans SQLite.
- Au lancement de l'application (`main.dart`), un `SyncService.syncAll(db)` est lancé pour envoyer toute donnée qui n'aurait pas été synchronisée pendant une coupure internet.

## 4. INTERFACE UTILISATEUR (UI)
L'interface est construite avec un thème sombre personnalisé (`lib/theme/app_theme.dart`).
La navigation principale est gérée par `lib/ui/layout/main_layout.dart` qui contient une `NavigationRail` à gauche avec un **indicateur de connexion réseau (Supabase) en bas**.

L'application contient 7 écrans majeurs / onglets :
1. **Dashboard** : Affiche les KPI (Clients, CA, Passages), un graphique des ventes, et les statistiques des coiffeurs actifs. Les données sont agrégées par `dashboard_provider.dart`.
2. **Paiement** : Formulaire complexe gérant la création d'une visite. Intègre une logique automatique de fidélité (calcul des coupes gratuites). Génère un reçu PDF à la validation via `pdf_service.dart`. Propose également de lier un RDV en attente pour le pré-remplissage automatique.
3. **Rendez-vous** : Onglet complet de gestion des RDV avec 3 vues (Liste, Jour, Semaine), création via formulaire dialog, et actions (Honoré/Annulé/Supprimer). Badge rouge sur l'icône sidebar indique les RDV du jour en attente.
4. **Clients** : Liste des clients avec fonction de recherche et formulaire d'ajout.
5. **Coiffeurs** : Liste et gestion des coiffeurs du salon.
6. **Inventaire** : Outil de reporting. Filtre les visites par période (Journalier, Mensuel, etc.), affiche des KPIs dynamiques et permet de générer un rapport PDF complet.
7. **Paramètres** : Onglet (accessible en bas à gauche) permettant de changer le nom du salon, basculer le thème (clair/sombre), et définir un mot de passe de verrouillage au démarrage de l'app.

## 5. RÈGLES À RESPECTER POUR L'IA SUIVANTE
1. **Ne jamais modifier les tables Drift existantes** sans générer la migration SQLite appropriée (via `schemaVersion` dans `database.dart`).
2. **Ne pas casser le mode Hors-ligne** : Si une fonctionnalité nécessite Supabase, elle doit avoir un fallback local SQLite. Le logiciel doit pouvoir tourner à 100% sans internet.
3. **Maintenir l'esthétique** : Le thème sombre, les cartes arrondies, les icônes et les micro-animations font partie du cahier des charges "Premium". Ne pas utiliser de couleurs primaires basiques ou de designs plats sans réflexion.
4. **Génération de code** : Après modification des tables Drift, toujours exécuter `dart run build_runner build` (ou la commande flutter équivalente) pour regénérer `database.g.dart`.
5. **Utilisation de `copyWith` avec Drift** : Lorsque vous utilisez la méthode `copyWith` générée par Drift pour mettre à jour une entité (ex: `Coiffeur`, `Client`), les champs optionnels nécessitent d'être enveloppés dans une `Value<T>` (ex: `Value(valeur)` ou `const Value(null)` pour forcer la mise à null). Il faut également importer `package:drift/drift.dart hide Column;` dans les fichiers concernés pour avoir accès à la classe `Value`.
6. **Ne jamais utiliser de couleurs hardcodées dans les écrans** : Toujours utiliser `Theme.of(context).scaffoldBackgroundColor`, `Theme.of(context).colorScheme.surface`, `Theme.of(context).textTheme`, etc. afin que le basculement Clair/Sombre fonctionne partout.
7. **Couleur des boutons** : Accessible via `Theme.of(context).colorScheme.tertiary`. Ne pas la recoder en dur. Pour lire/modifier, utiliser `ref.watch(buttonColorProvider)` (depuis `lib/providers/color_provider.dart`).

## 6. ÉTAT D'AVANCEMENT ACTUEL
- Le code UI est complet et fonctionnel.
- La base de données locale (SQLite) est complète avec sa logique métier de fidélité. (Migration vers la version 3 effectuée pour ajouter l'adresse aux coiffeurs).
- La génération des PDFs (Reçus et Rapports d'inventaire) est implémentée (`pdf_service.dart`). Le rapport d'inventaire inclut désormais des cartes visuelles KPI (style sombre).
- L'intégration cloud Supabase (création du schéma SQL, configuration, ajout du plugin, branchement sur les formulaires de paiement et d'ajout, et indicateur de status réseau) a été finalisée. Le schéma côté Supabase doit être créé par l'utilisateur via le fichier `supabase_schema.sql` fourni à la racine (incluant la migration v3 pour l'adresse).
- Les fonctionnalités de modification ont été ajoutées pour les Coiffeurs (tous les champs) et les Clients (restreint au nom, prénom et téléphone).
- **L'onglet Paramètres a été implémenté** : Il utilise Drift (migration v4 vers la table `Parametres`) pour stocker le nom du salon, le thème et le mot de passe. Le système de verrouillage (LoginScreen) s'active automatiquement si un mot de passe est défini. Les PDFs s'adaptent désormais dynamiquement au nom du salon.
- **Couleur des boutons personnalisable** : La couleur des boutons est stockée dans `shared_preferences` (clé: `button_color`) via `lib/providers/color_provider.dart`. La palette de 10 couleurs est disponible dans les Paramètres. La valeur par défaut est le violet `0xFF5E54A4`. Le thème (`app_theme.dart`) accepte maintenant un paramètre `buttonColor` dans ses fonctions `darkTheme(buttonColor:)` et `lightTheme(buttonColor:)`.
- **Thème clair corrigé** : Les couleurs hardcodées (ex: `Color(0xFF121212)`, `Colors.white`) ont été remplacées dans tous les écrans par des appels `Theme.of(context)` pour que le thème clair s'applique partout.
- **L'onglet Rendez-vous a été implémenté** : Migration Drift v5, table `RendezVous`, providers (`rendez_vous_provider.dart`), écran 3 vues (`rendez_vous_screen.dart`), formulaire de création (`nouveau_rdv_screen.dart`). Lien avec l'onglet Paiement pour pré-remplissage et marquage automatique 'honore'. Badge sidebar avec compteur temps réel. Synchronisation Supabase via `syncRendezVous` et intégration dans `syncAll`.

## 7. SCRIPT SQL SUPABASE — TABLE rendez_vous

À créer manuellement dans le projet Supabase :

```sql
CREATE TABLE rendez_vous (
  id BIGINT PRIMARY KEY,
  client_id BIGINT REFERENCES clients(id),
  coiffeur_id BIGINT REFERENCES coiffeurs(id),
  date_rdv TIMESTAMPTZ NOT NULL,
  type_coupe TEXT NOT NULL,
  statut TEXT NOT NULL DEFAULT 'en_attente',
  note TEXT,
  date_creation TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE rendez_vous REPLICA IDENTITY FULL;
```
