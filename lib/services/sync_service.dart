import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/database.dart';

class SyncService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// Vérifier si Supabase est accessible
  static Future<bool> isConnected() async {
    try {
      await _client.from('clients').select('id').limit(1);
      return true;
    } catch (e) {
      debugPrint('[SyncService] Supabase non accessible: $e');
      return false;
    }
  }

  /// Sync un client vers Supabase (upsert)
  static Future<void> syncClient(Client client) async {
    try {
      await _client.from('clients').upsert({
        'id': client.id,
        'nom': client.nom,
        'prenom': client.prenom,
        'telephone': client.telephone,
        'notes': client.notes,
        'total_coupes': client.totalCoupes,
        'gratuites_disponibles': client.gratuitesDisponibles,
        'date_creation': client.dateCreation.toIso8601String(),
      });
      debugPrint('[SyncService] Client ${client.id} synced');
    } catch (e) {
      debugPrint('[SyncService] Erreur sync client ${client.id}: $e');
    }
  }

  /// Sync un coiffeur vers Supabase (upsert)
  static Future<void> syncCoiffeur(Coiffeur coiffeur) async {
    try {
      await _client.from('coiffeurs').upsert({
        'id': coiffeur.id,
        'nom': coiffeur.nom,
        'prenom': coiffeur.prenom,
        'specialite': coiffeur.specialite,
        'actif': coiffeur.actif,
        'photo_path': coiffeur.photoPath,
        'nationalite': coiffeur.nationalite,
        'lieu_naissance': coiffeur.lieuNaissance,
        'date_naissance': coiffeur.dateNaissance?.toIso8601String(),
        'adresse': coiffeur.adresse,
      });
      debugPrint('[SyncService] Coiffeur ${coiffeur.id} synced');
    } catch (e) {
      debugPrint('[SyncService] Erreur sync coiffeur ${coiffeur.id}: $e');
    }
  }

  /// Sync une visite vers Supabase (upsert)
  static Future<void> syncVisite(Visite visite) async {
    try {
      await _client.from('visites').upsert({
        'id': visite.id,
        'client_id': visite.clientId,
        'coiffeur_id': visite.coiffeurId,
        'date_visite': visite.dateVisite.toIso8601String(),
        'type_coupe': visite.typeCoupe,
        'montant': visite.montant,
        'est_gratuite': visite.estGratuite,
        'note': visite.note,
      });
      debugPrint('[SyncService] Visite ${visite.id} synced');
    } catch (e) {
      debugPrint('[SyncService] Erreur sync visite ${visite.id}: $e');
    }
  }

  /// Resynchronise TOUTES les donnees locales vers Supabase
  static Future<void> syncAll(AppDatabase db) async {
    try {
      debugPrint('[SyncService] Debut syncAll...');

      // Sync tous les clients
      final clients = await db.select(db.clients).get();
      for (final client in clients) {
        await syncClient(client);
      }
      debugPrint('[SyncService] ${clients.length} clients synced');

      // Sync tous les coiffeurs
      final coiffeurs = await db.select(db.coiffeurs).get();
      for (final coiffeur in coiffeurs) {
        await syncCoiffeur(coiffeur);
      }
      debugPrint('[SyncService] ${coiffeurs.length} coiffeurs synced');

      // Sync toutes les visites
      final visites = await db.select(db.visites).get();
      for (final visite in visites) {
        await syncVisite(visite);
      }
      debugPrint('[SyncService] ${visites.length} visites synced');

      debugPrint('[SyncService] syncAll termine avec succes !');
    } catch (e) {
      debugPrint('[SyncService] Erreur syncAll: $e');
    }
  }
}
