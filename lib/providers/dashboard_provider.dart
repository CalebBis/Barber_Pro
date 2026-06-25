import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../data/database.dart';
import 'database_provider.dart';
import 'clients_provider.dart';
import 'coiffeurs_provider.dart';
import 'visites_provider.dart';

class DashboardData {
  final int totalClients;
  final int nouveauxClientsMois;
  final int passagesToday;
  final int passagesHier;
  final int caToday;
  final int caHier;
  final int gratuitesEnCours;
  final List<Visite> derniersClients;
  final Map<Coiffeur, int> coiffeursActifs;

  DashboardData({
    required this.totalClients,
    required this.nouveauxClientsMois,
    required this.passagesToday,
    required this.passagesHier,
    required this.caToday,
    required this.caHier,
    required this.gratuitesEnCours,
    required this.derniersClients,
    required this.coiffeursActifs,
  });
}

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final db = ref.watch(databaseProvider);
  
  // Watch other providers to trigger auto-updates
  ref.watch(clientsProvider);
  ref.watch(coiffeursProvider);
  ref.watch(visitesProvider);

  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));
  final startOfHier = startOfDay.subtract(const Duration(days: 1));
  final startOfMonth = DateTime(now.year, now.month, 1);

  // Total clients
  final clients = await db.select(db.clients).get();
  final totalClients = clients.length;
  final nouveauxClientsMois = clients.where((c) => c.dateCreation.isAfter(startOfMonth) || c.dateCreation.isAtSameMomentAs(startOfMonth)).length;

  // Gratuites en cours
  final gratuitesEnCours = clients.fold<int>(0, (sum, c) => sum + c.gratuitesDisponibles);

  // Visites d'aujourd'hui
  final visitesToday = await (db.select(db.visites)
        ..where((t) => t.dateVisite.isBiggerOrEqualValue(startOfDay))
        ..where((t) => t.dateVisite.isSmallerThanValue(endOfDay))
        ..orderBy([(t) => OrderingTerm(expression: t.dateVisite, mode: OrderingMode.desc)]))
      .get();

  final passagesToday = visitesToday.length;
  final caToday = visitesToday.fold<int>(0, (sum, v) => sum + v.montant);

  // Visites d'hier
  final visitesHier = await (db.select(db.visites)
        ..where((t) => t.dateVisite.isBiggerOrEqualValue(startOfHier))
        ..where((t) => t.dateVisite.isSmallerThanValue(startOfDay)))
      .get();
      
  final passagesHier = visitesHier.length;
  final caHier = visitesHier.fold<int>(0, (sum, v) => sum + v.montant);

  // Coiffeurs actifs et nombre de clients
  final coiffeurs = await (db.select(db.coiffeurs)..where((t) => t.actif.equals(true))).get();
  final Map<Coiffeur, int> coiffeursMap = {};
  for (var c in coiffeurs) {
    final count = visitesToday.where((v) => v.coiffeurId == c.id).length;
    coiffeursMap[c] = count;
  }

  return DashboardData(
    totalClients: totalClients,
    nouveauxClientsMois: nouveauxClientsMois,
    passagesToday: passagesToday,
    passagesHier: passagesHier,
    caToday: caToday,
    caHier: caHier,
    gratuitesEnCours: gratuitesEnCours,
    derniersClients: visitesToday.take(10).toList(),
    coiffeursActifs: coiffeursMap,
  );
});
