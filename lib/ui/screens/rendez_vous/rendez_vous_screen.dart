import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/rendez_vous_provider.dart';
import '../../../providers/clients_provider.dart';
import '../../../providers/coiffeurs_provider.dart';
import '../../../providers/database_provider.dart';
import '../../../data/database.dart';
import 'nouveau_rdv_screen.dart';

class RendezVousScreen extends ConsumerWidget {
  const RendezVousScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vue = ref.watch(vueRdvProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rendez-vous',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const NouveauRdvScreen(),
                    );
                  },
                  icon: Icon(Icons.add, color: theme.colorScheme.onTertiary),
                  label: Text('Nouveau RDV', style: TextStyle(color: theme.colorScheme.onTertiary)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // View Toggles
            Row(
              children: [
                _buildViewButton(context, ref, VueRdv.jour, 'Jour'),
                const SizedBox(width: 8),
                _buildViewButton(context, ref, VueRdv.semaine, 'Semaine'),
                const SizedBox(width: 8),
                _buildViewButton(context, ref, VueRdv.liste, 'Liste'),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: _buildContent(context, ref, vue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewButton(BuildContext context, WidgetRef ref, VueRdv viewValue, String label) {
    final currentView = ref.watch(vueRdvProvider);
    final isSelected = currentView == viewValue;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => ref.read(vueRdvProvider.notifier).state = viewValue,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.tertiary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? theme.colorScheme.tertiary : theme.colorScheme.onSurface.withOpacity(0.12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.onTertiary : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, VueRdv vue) {
    switch (vue) {
      case VueRdv.liste:
        return const _VueListe();
      case VueRdv.jour:
        return const _VueJour();
      case VueRdv.semaine:
        return const _VueSemaine();
    }
  }
}

// ==========================================
// VUE LISTE
// ==========================================
class _VueListe extends ConsumerWidget {
  const _VueListe();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rdvsAsync = ref.watch(rendezVousProvider);
    final clientsAsync = ref.watch(clientsProvider);
    final coiffeursAsync = ref.watch(coiffeursProvider);

    if (rdvsAsync.isLoading || clientsAsync.isLoading || coiffeursAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final rdvs = rdvsAsync.value ?? [];
    if (rdvs.isEmpty) {
      return _buildEmptyState(context);
    }

    // Grouper par date
    final Map<String, List<RendezVousData>> grouped = {};
    for (var rdv in rdvs) {
      final dateStr = DateFormat('yyyy-MM-dd').format(rdv.dateRdv);
      grouped.putIfAbsent(dateStr, () => []).add(rdv);
    }

    final sortedDates = grouped.keys.toList()..sort();

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateStr = sortedDates[index];
        final dayRdvs = grouped[dateStr]!;
        
        DateTime dateObj = DateTime.parse(dateStr);
        String headerTitle;
        final now = DateTime.now();
        final todayStr = DateFormat('yyyy-MM-dd').format(now);
        final tomorrowStr = DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 1)));
        
        if (dateStr == todayStr) {
          headerTitle = "Aujourd'hui";
        } else if (dateStr == tomorrowStr) {
          headerTitle = "Demain";
        } else {
          headerTitle = toBeginningOfSentenceCase(DateFormat('EEEE d MMMM', 'fr_FR').format(dateObj)) ?? dateStr;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                headerTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
            ...dayRdvs.map((rdv) => _buildRdvCard(context, ref, rdv, clientsAsync.value ?? [], coiffeursAsync.value ?? [])).toList(),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            "Aucun rendez-vous à venir",
            style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const NouveauRdvScreen(),
              );
            },
            child: const Text('Créer un RDV'),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// VUE JOUR
// ==========================================
class _VueJour extends ConsumerWidget {
  const _VueJour();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dateSelectionneeProvider);
    final theme = Theme.of(context);
    final rdvsAsync = ref.watch(rendezVousProvider);
    final clientsAsync = ref.watch(clientsProvider);
    final coiffeursAsync = ref.watch(coiffeursProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: theme.colorScheme.onSurface),
              onPressed: () => ref.read(dateSelectionneeProvider.notifier).state = date.subtract(const Duration(days: 1)),
            ),
            const SizedBox(width: 16),
            Text(
              toBeginningOfSentenceCase(DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(date)) ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface),
              onPressed: () => ref.read(dateSelectionneeProvider.notifier).state = date.add(const Duration(days: 1)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: rdvsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Erreur: $e')),
            data: (rdvs) {
              if (rdvs.isEmpty) {
                return Center(
                  child: Text("Aucun rendez-vous ce jour", style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5))),
                );
              }
              return ListView.builder(
                itemCount: rdvs.length,
                itemBuilder: (context, index) {
                  return _buildRdvCard(context, ref, rdvs[index], clientsAsync.value ?? [], coiffeursAsync.value ?? []);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==========================================
// VUE SEMAINE
// ==========================================
class _VueSemaine extends ConsumerWidget {
  const _VueSemaine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dateSelectionneeProvider);
    final theme = Theme.of(context);
    final rdvsAsync = ref.watch(rendezVousProvider);
    final clientsAsync = ref.watch(clientsProvider);
    
    // Calcul de la semaine (Lundi à Dimanche)
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final days = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: theme.colorScheme.onSurface),
              onPressed: () => ref.read(dateSelectionneeProvider.notifier).state = date.subtract(const Duration(days: 7)),
            ),
            Text(
              "Semaine du ${DateFormat('d MMM').format(startOfWeek)} au ${DateFormat('d MMM yyyy').format(days.last)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface),
              onPressed: () => ref.read(dateSelectionneeProvider.notifier).state = date.add(const Duration(days: 7)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: rdvsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Erreur: $e')),
            data: (rdvs) {
              return Row(
                children: days.map((day) {
                  final dayRdvs = rdvs.where((r) => r.dateRdv.year == day.year && r.dateRdv.month == day.month && r.dateRdv.day == day.day).toList();
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: day.day == DateTime.now().day && day.month == DateTime.now().month && day.year == DateTime.now().year
                                ? theme.colorScheme.tertiary.withOpacity(0.2)
                                : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                            ),
                            child: Center(
                              child: Text(
                                DateFormat('E d', 'fr_FR').format(day).toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: dayRdvs.length,
                              itemBuilder: (context, index) {
                                final rdv = dayRdvs[index];
                                final clients = clientsAsync.value ?? [];
                                final client = clients.firstWhere((c) => c.id == rdv.clientId, orElse: () => clients.first);
                                return InkWell(
                                  onTap: () {
                                    // Affiche les infos du RDV si on clique dessus
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('RDV - ${DateFormat('HH:mm').format(rdv.dateRdv)}'),
                                        content: Text('Client: ${client.prenom} ${client.nom}\nType: ${rdv.typeCoupe}\nStatut: ${rdv.statut}'),
                                      )
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border(left: BorderSide(color: _getStatutColor(rdv.statut), width: 3)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(DateFormat('HH:mm').format(rdv.dateRdv), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: theme.colorScheme.onSurface)),
                                        Text(client.prenom, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface), overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getStatutColor(String statut) {
    if (statut == 'en_attente') return Colors.amber;
    if (statut == 'honore') return Colors.green;
    return Colors.red;
  }
}

// ==========================================
// WIDGET CARD COMMUN
// ==========================================
Widget _buildRdvCard(BuildContext context, WidgetRef ref, RendezVousData rdv, List<Client> clients, List<Coiffeur> coiffeurs) {
  final client = clients.firstWhere((c) => c.id == rdv.clientId, orElse: () => clients.first);
  final coiffeur = coiffeurs.firstWhere((c) => c.id == rdv.coiffeurId, orElse: () => coiffeurs.first);
  
  final theme = Theme.of(context);
  final timeStr = DateFormat('HH:mm').format(rdv.dateRdv);
  
  Color statutColor;
  String statutLabel;
  if (rdv.statut == 'en_attente') {
    statutColor = Colors.amber;
    statutLabel = 'En attente';
  } else if (rdv.statut == 'honore') {
    statutColor = Colors.green;
    statutLabel = 'Honoré';
  } else {
    statutColor = Colors.red;
    statutLabel = 'Annulé';
  }

  return Card(
    color: theme.colorScheme.surfaceContainer,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(timeStr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(width: 24),
          CircleAvatar(
            backgroundColor: theme.colorScheme.tertiary.withOpacity(0.2),
            child: Text(
              client.prenom.isNotEmpty ? client.prenom[0].toUpperCase() : '?',
              style: TextStyle(color: theme.colorScheme.tertiary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${client.prenom} ${client.nom}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)),
                Text('Coiffeur : ${coiffeur.prenom} ${coiffeur.nom}', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
              ],
            ),
          ),
          // Badges
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(rdv.typeCoupe, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statutColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(statutLabel, style: TextStyle(color: statutColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 24),
          
          // Actions
          if (rdv.statut == 'en_attente') ...[
            IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              tooltip: 'Marquer comme honoré',
              onPressed: () {
                 ref.read(databaseProvider).updateStatutRdv(rdv.id, 'honore').then((_) => ref.invalidate(rendezVousProvider));
              },
            ),
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              tooltip: 'Marquer comme annulé',
              onPressed: () {
                ref.read(databaseProvider).updateStatutRdv(rdv.id, 'annule').then((_) => ref.invalidate(rendezVousProvider));
              },
            ),
          ],
          IconButton(
            icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            tooltip: 'Supprimer',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: theme.colorScheme.surface,
                  title: Text('Supprimer le RDV ?', style: TextStyle(color: theme.colorScheme.onSurface)),
                  content: Text('Voulez-vous vraiment supprimer ce rendez-vous ?', style: TextStyle(color: theme.colorScheme.onSurface)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error, foregroundColor: theme.colorScheme.onError),
                      onPressed: () => Navigator.pop(context, true), 
                      child: const Text('Supprimer')
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await ref.read(databaseProvider).supprimerRendezVous(rdv.id);
                ref.invalidate(rendezVousProvider);
              }
            },
          ),
        ],
      ),
    ),
  );
}
