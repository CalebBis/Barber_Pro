import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../data/database.dart';
import 'database_provider.dart';

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Parametre>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends AsyncNotifier<Parametre> {
  @override
  Future<Parametre> build() async {
    final db = ref.watch(databaseProvider);
    // On s'assure de récupérer la première ligne (id = 1)
    final query = db.select(db.parametres)..where((t) => t.id.equals(1));
    final result = await query.getSingleOrNull();
    
    if (result != null) {
      return result;
    } else {
      // Cas de fallback si la migration n'a pas inséré la ligne
      final id = await db.into(db.parametres).insert(
        ParametresCompanion.insert(
          nomSalon: const Value('Benji Coiffure'),
          themeClair: const Value(false),
        ),
      );
      return (await (db.select(db.parametres)..where((t) => t.id.equals(id))).getSingleOrNull())!;
    }
  }

  Future<void> updateSettings(Parametre parametre) async {
    final db = ref.read(databaseProvider);
    await db.update(db.parametres).replace(parametre);
    ref.invalidateSelf();
  }
}
