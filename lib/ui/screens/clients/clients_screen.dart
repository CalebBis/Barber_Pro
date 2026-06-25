import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/clients_provider.dart';
import '../../../providers/visites_provider.dart';
import '../../../data/database.dart';
import 'package:drift/drift.dart' hide Column;

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  String _searchQuery = '';

  String _formatDateString(DateTime? date) {
    if (date == null) return '—';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0 && now.day == date.day) {
      return "Aujourd'hui";
    } else if (diff.inDays == 1) {
      return "Hier";
    } else if (diff.inDays < 7) {
      return "Il y a ${diff.inDays} jours";
    } else if (diff.inDays < 14) {
      return "Il y a 1 semaine";
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(clientsProvider);
    final visitesState = ref.watch(visitesProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Clients',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddClientDialog(context, ref),
                  icon: Icon(Icons.add, size: 18),
                  label: Text(
                    'Nouveau client',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Main Card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),
                    ),

                    // Table Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Client',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Telephone',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Total\ncoupes',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Gratuites\ndispo',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Derniere\nvisite',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(height: 1, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),

                    // Table Body
                    Expanded(
                      child: clientsState.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) =>
                            Center(child: Text('Erreur: $err')),
                        data: (clients) {
                          final filtered = clients.where((c) {
                            final search = _searchQuery.toLowerCase();
                            return c.nom.toLowerCase().contains(search) ||
                                c.prenom.toLowerCase().contains(search) ||
                                (c.telephone ?? '').contains(search);
                          }).toList();

                          final allVisites =
                              visitesState.asData?.value ?? [];

                          if (filtered.isEmpty) {
                            return Center(
                              child: Text(
                                'Aucun client trouve.',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                            itemBuilder: (context, index) {
                              final c = filtered[index];

                              final clientVisites = allVisites
                                  .where((v) => v.clientId == c.id)
                                  .toList()
                                ..sort((a, b) =>
                                    b.dateVisite.compareTo(a.dateVisite));
                              final lastVisitDate = clientVisites.isNotEmpty
                                  ? clientVisites.first.dateVisite
                                  : null;

                              Color badgeColor;
                              if (c.gratuitesDisponibles == 1) {
                                badgeColor = const Color(0xFF1E4620);
                              } else if (c.gratuitesDisponibles >= 2) {
                                badgeColor = const Color(0xFF5E452B);
                              } else {
                                badgeColor = Colors.transparent;
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 16.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${c.prenom}\n${c.nom}',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        c.telephone ?? '—',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        c.totalCoupes.toString(),
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: c.gratuitesDisponibles > 0
                                            ? Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: badgeColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  c.gratuitesDisponibles
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: c.gratuitesDisponibles ==
                                                            1
                                                        ? Colors.greenAccent
                                                        : Colors.orange,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                '—',
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _formatDateString(lastVisitDate),
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.onSurface,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54), size: 20),
                                            onPressed: () => _showEditClientDialog(context, ref, c),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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

  void _showAddClientDialog(BuildContext context, WidgetRef ref) {
    final nomController = TextEditingController();
    final prenomController = TextEditingController();
    final telController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau Client'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: prenomController,
                decoration: const InputDecoration(labelText: 'Prenom'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telController,
                decoration: const InputDecoration(labelText: 'Telephone'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nomController.text.isNotEmpty &&
                  prenomController.text.isNotEmpty) {
                ref.read(clientsProvider.notifier).addClient(
                      nomController.text,
                      prenomController.text,
                      telController.text,
                      notesController.text,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showEditClientDialog(BuildContext context, WidgetRef ref, Client client) {
    final nomController = TextEditingController(text: client.nom);
    final prenomController = TextEditingController(text: client.prenom);
    final telController = TextEditingController(text: client.telephone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier Client'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Note: L\'historique et la fidélité ne peuvent pas être modifiés manuellement.',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nomController.text.isNotEmpty && prenomController.text.isNotEmpty) {
                final updated = client.copyWith(
                  nom: nomController.text,
                  prenom: prenomController.text,
                  telephone: telController.text.isEmpty ? const Value(null) : Value(telController.text),
                );
                ref.read(clientsProvider.notifier).updateClient(updated);
                Navigator.pop(context);
              }
            },
            child: const Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }
}
