import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../data/database.dart';
import 'database_provider.dart';
import 'clients_provider.dart';
import 'coiffeurs_provider.dart';
import 'visites_provider.dart';

enum GraphiquePeriode { sept, trente, mensuel, annuel }

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
    derniersClients: visitesToday.take(5).toList(),
    coiffeursActifs: coiffeursMap,
  );
});

final graphiquePeriodeProvider = StateProvider<GraphiquePeriode>(
  (ref) => GraphiquePeriode.trente,
);

final graphiqueDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final periode = ref.watch(graphiquePeriodeProvider);
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();

  DateTime startDate;
  switch (periode) {
    case GraphiquePeriode.sept:
      startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
      break;
    case GraphiquePeriode.trente:
      startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 29));
      break;
    case GraphiquePeriode.mensuel:
      startDate = DateTime(now.year, now.month - 11, 1);
      break;
    case GraphiquePeriode.annuel:
      startDate = DateTime(now.year - 2, 1, 1);
      break;
  }

  final visites = await (db.select(db.visites)
        ..where((t) => t.montant.isBiggerThanValue(0))
        ..where((t) => t.dateVisite.isBiggerOrEqualValue(startDate))
      ).get();

  List<Map<String, dynamic>> results = [];

  String getMonthName(int month) {
    const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
    int normalizedMonth = month % 12;
    if (normalizedMonth == 0) normalizedMonth = 12;
    return months[normalizedMonth - 1];
  }

  if (periode == GraphiquePeriode.sept || periode == GraphiquePeriode.trente) {
    int days = periode == GraphiquePeriode.sept ? 7 : 30;
    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final label = "${date.day}/${date.month}";
      final sum = visites
          .where((v) => v.dateVisite.year == date.year && v.dateVisite.month == date.month && v.dateVisite.day == date.day)
          .fold<int>(0, (prev, v) => prev + v.montant);
      results.add({'label': label, 'ca': sum});
    }
  } else if (periode == GraphiquePeriode.mensuel) {
    for (int i = 11; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthStr = getMonthName(date.month);
      final sum = visites
          .where((v) => v.dateVisite.year == date.year && v.dateVisite.month == date.month)
          .fold<int>(0, (prev, v) => prev + v.montant);
      results.add({'label': monthStr, 'ca': sum});
    }
  } else if (periode == GraphiquePeriode.annuel) {
    for (int i = 2; i >= 0; i--) {
      final year = now.year - i;
      final sum = visites
          .where((v) => v.dateVisite.year == year)
          .fold<int>(0, (prev, v) => prev + v.montant);
      results.add({'label': year.toString(), 'ca': sum});
    }
  }

  return results;
});
