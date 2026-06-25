import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Clients, Coiffeurs, Visites, Parametres])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(coiffeurs, coiffeurs.photoPath);
          await m.addColumn(coiffeurs, coiffeurs.nationalite);
          await m.addColumn(coiffeurs, coiffeurs.lieuNaissance);
          await m.addColumn(coiffeurs, coiffeurs.dateNaissance);
        }
        if (from < 3) {
          await m.addColumn(coiffeurs, coiffeurs.adresse);
        }
        if (from < 4) {
          await m.createTable(parametres);
          await into(parametres).insert(
            ParametresCompanion.insert(
              nomSalon: const Value('Benji Coiffure'),
              themeClair: const Value(false),
            ),
          );
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'barber_pro.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
