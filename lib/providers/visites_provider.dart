import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../data/database.dart';
import 'database_provider.dart';
import 'clients_provider.dart';
import '../services/sync_service.dart';

final visitesProvider = AsyncNotifierProvider<VisitesNotifier, List<Visite>>(() {
  return VisitesNotifier();
});

class VisitesNotifier extends AsyncNotifier<List<Visite>> {
  @override
  Future<List<Visite>> build() async {
    final db = ref.watch(databaseProvider);
    return (db.select(db.visites)
          ..orderBy([(t) => OrderingTerm(expression: t.dateVisite, mode: OrderingMode.desc)]))
        .get();
  }

  Future<void> addVisite({
    required Client client,
    required Coiffeur coiffeur,
    required String typeCoupe,
    required int montant,
    required bool estGratuite,
    String? note,
    DateTime? dateVisite,
  }) async {
    final db = ref.read(databaseProvider);

    int? visiteId;

    await db.transaction(() async {
      // 1. Ajouter la visite
      visiteId = await db.into(db.visites).insert(VisitesCompanion.insert(
        clientId: client.id,
        coiffeurId: coiffeur.id,
        typeCoupe: typeCoupe,
        montant: montant,
        estGratuite: Value(estGratuite),
        note: Value(note),
        dateVisite: Value(dateVisite ?? DateTime.now()),
      ));

      // 2. Mettre à jour la fidélité du client
      int newTotalCoupes = client.totalCoupes;
      int newGratuites = client.gratuitesDisponibles;

      if (estGratuite) {
        newGratuites -= 1;
        if (newGratuites < 0) newGratuites = 0; // Sécurité
      } else {
        newTotalCoupes += 1;
        // Si c'est un multiple de 4, on gagne une gratuite
        if (newTotalCoupes % 4 == 0) {
          newGratuites += 1;
        }
      }

      // Mettre à jour le client en base
      await db.update(db.clients).replace(client.copyWith(
        totalCoupes: newTotalCoupes,
        gratuitesDisponibles: newGratuites,
      ));
    });

    if (visiteId != null) {
      final newVisite = await (db.select(db.visites)..where((t) => t.id.equals(visiteId!))).getSingle();
      final updatedClient = await (db.select(db.clients)..where((t) => t.id.equals(client.id))).getSingle();
      
      SyncService.syncVisite(newVisite);
      SyncService.syncClient(updatedClient);
    }

    // 3. Rafraîchir les états
    ref.invalidateSelf();
    ref.invalidate(clientsProvider);
  }
}
