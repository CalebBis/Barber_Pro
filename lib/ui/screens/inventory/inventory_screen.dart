import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/visites_provider.dart';
import '../../../providers/clients_provider.dart';
import '../../../providers/coiffeurs_provider.dart';
import '../../../data/database.dart';
import '../../../services/pdf_service.dart';
import '../../../providers/settings_provider.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _periode = 'Mensuel';

  final List<String> _periodes = ['Journalier', 'Hebdo', 'Mensuel', 'Semestriel', 'Annuel'];

  DateTime get _dateDebut {
    final now = DateTime.now();
    switch (_periode) {
      case 'Journalier':
        return DateTime(now.year, now.month, now.day);
      case 'Hebdo':
        return now.subtract(Duration(days: now.weekday - 1));
      case 'Mensuel':
        return DateTime(now.year, now.month, 1);
      case 'Semestriel':
        return DateTime(now.year, now.month > 6 ? 7 : 1, 1);
      case 'Annuel':
        return DateTime(now.year, 1, 1);
      default:
        return DateTime(now.year, now.month, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visitesAsync = ref.watch(visitesProvider);
    final clientsAsync = ref.watch(clientsProvider);
    final coiffeursAsync = ref.watch(coiffeursProvider);
    final settingsAsync = ref.watch(settingsProvider);

    if (visitesAsync.isLoading || clientsAsync.isLoading || coiffeursAsync.isLoading || settingsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final nomSalon = settingsAsync.maybeWhen(data: (s) => s.nomSalon, orElse: () => 'Benji Coiffure');

    final visites = visitesAsync.value ?? [];
    final clients = clientsAsync.value ?? [];
    final coiffeurs = coiffeursAsync.value ?? [];

    final visitesFiltrees = visites.where((v) => v.dateVisite.isAfter(_dateDebut)).toList();
    final nouveauxClients = clients.where((c) => c.dateCreation.isAfter(_dateDebut)).length;

    final passages = visitesFiltrees.length;
    final caTotal = visitesFiltrees.fold<int>(0, (sum, v) => sum + v.montant);
    final gratuitesUtilisees = visitesFiltrees.where((v) => v.estGratuite).length;

    final format = NumberFormat('#,###', 'fr_FR');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inventaire & rapports',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    PdfService.generateInventoryReport(
                      periode: _periode,
                      visites: visitesFiltrees,
                      clients: clients,
                      coiffeurs: coiffeurs,
                      caTotal: caTotal,
                      passages: passages,
                      nouveauxClients: nouveauxClients,
                      gratuitesUtilisees: gratuitesUtilisees,
                      salonName: nomSalon,
                    );
                  },
                  icon: Icon(Icons.download, size: 18),
                  label: Text('Exporter PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.24)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Period filter chips
            Row(
              children: _periodes.map((p) {
                final isSelected = _periode == p;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => setState(() => _periode = p),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).colorScheme.tertiary : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Theme.of(context).colorScheme.onSurface.withOpacity(0.24) : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                        ),
                      ),
                      child: Text(
                        p,
                        style: TextStyle(
                          color: isSelected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24),

            // Main content card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // KPI cards row
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          _buildKpiCard('Passages', passages.toString()),
                          SizedBox(width: 12),
                          _buildKpiCard('CA total\n(FC)', format.format(caTotal)),
                          SizedBox(width: 12),
                          _buildKpiCard('Gratuites\nutilisees', gratuitesUtilisees.toString()),
                          SizedBox(width: 12),
                          _buildKpiCard('Nouveaux\nclients', nouveauxClients.toString()),
                        ],
                      ),
                    ),

                    // Table header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text('Heure', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38), fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text('Client', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38), fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text('Coiffeur', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38), fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text('Prestation', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38), fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('Montant\n(FC)', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38), fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('Type', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38), fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(height: 1, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),

                    // Table body
                    Expanded(
                      child: visitesFiltrees.isEmpty
                          ? Center(child: Text('Aucune donnee pour cette periode.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54))))
                          : ListView.separated(
                              itemCount: visitesFiltrees.length,
                              separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                              itemBuilder: (context, index) {
                                final v = visitesFiltrees[index];
                                final client = clients.firstWhere(
                                  (c) => c.id == v.clientId,
                                  orElse: () => Client(id: 0, nom: 'Inconnu', prenom: '', telephone: null, notes: null, totalCoupes: 0, gratuitesDisponibles: 0, dateCreation: DateTime.now()),
                                );
                                final coiffeur = coiffeurs.firstWhere(
                                  (c) => c.id == v.coiffeurId,
                                  orElse: () => Coiffeur(id: 0, nom: 'Inconnu', prenom: '', specialite: null, actif: false),
                                );

                                final heure = DateFormat('HH\'h\'mm').format(v.dateVisite);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(heure, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.70), fontSize: 15)),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${client.prenom}\n${client.nom}',
                                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${coiffeur.prenom}\n${coiffeur.nom}',
                                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Coupe\n${v.typeCoupe.toLowerCase()}',
                                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 15),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          v.estGratuite ? '0' : format.format(v.montant),
                                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 15),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          v.estGratuite ? 'Fidelite' : 'Paye',
                                          style: TextStyle(
                                            color: v.estGratuite ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54), fontSize: 13),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }
}
