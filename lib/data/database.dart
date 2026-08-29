import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Clients, Coiffeurs, Visites, Parametres, RendezVous])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

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
        if (from < 5) {
          await m.createTable(rendezVous);
        }
        if (from < 6) {
          await m.addColumn(coiffeurs, coiffeurs.telephone);
        }
      },
    );
  }

  // --- RendezVous ---
  Future<List<RendezVousData>> getRendezVousByJour(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return (select(rendezVous)
          ..where((r) => r.dateRdv.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(r) => OrderingTerm(expression: r.dateRdv)]))
        .get();
  }

  Future<List<RendezVousData>> getRendezVousBySemaine(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final end = start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    return (select(rendezVous)
          ..where((r) => r.dateRdv.isBetweenValues(start, end))
          ..orderBy([(r) => OrderingTerm(expression: r.dateRdv)]))
        .get();
  }

  Future<List<RendezVousData>> getRendezVousAVenir() {
    return (select(rendezVous)
          ..where((r) => r.dateRdv.isBiggerOrEqualValue(DateTime.now()))
          ..orderBy([(r) => OrderingTerm(expression: r.dateRdv)]))
        .get();
  }

  Future<void> creerRendezVous(RendezVousCompanion rdv) {
    return into(rendezVous).insert(rdv).then((value) => null);
  }

  Future<void> updateStatutRdv(int id, String statut) {
    return (update(rendezVous)..where((r) => r.id.equals(id)))
        .write(RendezVousCompanion(statut: Value(statut)));
  }

  Future<void> supprimerRendezVous(int id) {
    return (delete(rendezVous)..where((r) => r.id.equals(id))).go().then((value) => null);
  }

  Future<List<RendezVousData>> getRdvEnAttenteClient(int clientId) {
    return (select(rendezVous)
          ..where((r) => r.clientId.equals(clientId) & r.statut.equals('en_attente'))
          ..orderBy([(r) => OrderingTerm(expression: r.dateRdv)]))
        .get();
  }
}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'barber_pro.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
