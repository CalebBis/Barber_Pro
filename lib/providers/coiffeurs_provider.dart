import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../data/database.dart';
import 'database_provider.dart';
import '../services/sync_service.dart';

final coiffeursProvider = AsyncNotifierProvider<CoiffeursNotifier, List<Coiffeur>>(() {
  return CoiffeursNotifier();
});

class CoiffeursNotifier extends AsyncNotifier<List<Coiffeur>> {
  @override
  Future<List<Coiffeur>> build() async {
    final db = ref.watch(databaseProvider);
    return db.select(db.coiffeurs).get();
  }

  Future<void> addCoiffeur({
    required String nom,
    required String prenom,
    required String specialite,
    String? photoPath,
    String? nationalite,
    String? lieuNaissance,
    DateTime? dateNaissance,
    String? adresse,
  }) async {
    final db = ref.read(databaseProvider);
    final id = await db.into(db.coiffeurs).insert(CoiffeursCompanion.insert(
      nom: nom,
      prenom: prenom,
      specialite: Value(specialite),
      actif: const Value(true),
      photoPath: Value(photoPath),
      nationalite: Value(nationalite),
      lieuNaissance: Value(lieuNaissance),
      dateNaissance: Value(dateNaissance),
      adresse: Value(adresse),
    ));
    final newCoiffeur = await (db.select(db.coiffeurs)..where((t) => t.id.equals(id))).getSingle();
    SyncService.syncCoiffeur(newCoiffeur);
    ref.invalidateSelf();
  }

  Future<void> updateCoiffeur(Coiffeur coiffeur) async {
    final db = ref.read(databaseProvider);
    await db.update(db.coiffeurs).replace(coiffeur);
    SyncService.syncCoiffeur(coiffeur);
    ref.invalidateSelf();
  }
}
