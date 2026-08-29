import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import 'database_provider.dart';

// Filtre de vue
enum VueRdv { jour, semaine, liste }

final vueRdvProvider = StateProvider<VueRdv>((ref) => VueRdv.liste);

// Date sélectionnée dans le calendrier
final dateSelectionneeProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Liste des RDV selon la vue et la date
final rendezVousProvider = FutureProvider<List<RendezVousData>>((ref) async {
  final db = ref.watch(databaseProvider);
  final vue = ref.watch(vueRdvProvider);
  final date = ref.watch(dateSelectionneeProvider);

  switch (vue) {
    case VueRdv.jour:
      return await db.getRendezVousByJour(date);
    case VueRdv.semaine:
      return await db.getRendezVousBySemaine(date);
    case VueRdv.liste:
      return await db.getRendezVousAVenir();
  }
});

// RDV d'aujourd'hui pour le badge dans la sidebar
final rdvAujourdhuilProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(databaseProvider);
  final rdvs = await db.getRendezVousByJour(DateTime.now());
  return rdvs.where((r) => r.statut == 'en_attente').length;
});
