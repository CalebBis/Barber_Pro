import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../data/database.dart';
import 'database_provider.dart';
import '../services/sync_service.dart';

final clientsProvider = AsyncNotifierProvider<ClientsNotifier, List<Client>>(() {
  return ClientsNotifier();
});

class ClientsNotifier extends AsyncNotifier<List<Client>> {
  @override
  Future<List<Client>> build() async {
    final db = ref.watch(databaseProvider);
    return db.select(db.clients).get();
  }

  Future<void> addClient(String nom, String prenom, String telephone, String notes) async {
    final db = ref.read(databaseProvider);
    final id = await db.into(db.clients).insert(ClientsCompanion.insert(
      nom: nom,
      prenom: prenom,
      telephone: Value(telephone),
      notes: Value(notes),
    ));
    final newClient = await (db.select(db.clients)..where((t) => t.id.equals(id))).getSingle();
    SyncService.syncClient(newClient);
    ref.invalidateSelf();
  }

  Future<void> updateClient(Client client) async {
    final db = ref.read(databaseProvider);
    await db.update(db.clients).replace(client);
    SyncService.syncClient(client);
    ref.invalidateSelf();
  }
}
