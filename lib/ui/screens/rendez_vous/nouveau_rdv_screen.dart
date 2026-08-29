import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column, Row;
import '../../../providers/clients_provider.dart';
import '../../../providers/coiffeurs_provider.dart';
import '../../../providers/database_provider.dart';
import '../../../data/database.dart';
import '../../../utils/text_utils.dart';
import '../../../providers/rendez_vous_provider.dart';

class NouveauRdvScreen extends ConsumerStatefulWidget {
  const NouveauRdvScreen({super.key});

  @override
  ConsumerState<NouveauRdvScreen> createState() => _NouveauRdvScreenState();
}

class _NouveauRdvScreenState extends ConsumerState<NouveauRdvScreen> {
  int? _selectedClientId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _selectedCoiffeurId;
  String _typeCoupe = 'Classique';
  final TextEditingController _noteController = TextEditingController();

  final TextEditingController _clientSearchController = TextEditingController();
  final FocusNode _clientFocusNode = FocusNode();
  bool _showClientSuggestions = false;
  String _clientQuery = '';

  @override
  void dispose() {
    _clientSearchController.dispose();
    _clientFocusNode.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(DateTime.now()) ? DateTime.now() : _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientsAsync = ref.watch(clientsProvider);
    final coiffeursAsync = ref.watch(coiffeursProvider);

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nouveau Rendez-vous', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 24),
              
              // 1. Recherche client
              Text('Rechercher un client', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              clientsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => Text('Erreur: $e'),
                data: (clients) {
                  final filtered = clients.where((c) {
                    final q = _clientQuery.toLowerCase();
                    return q.isEmpty ||
                        c.prenom.toLowerCase().contains(q) ||
                        c.nom.toLowerCase().contains(q) ||
                        (c.telephone ?? '').contains(q);
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _clientSearchController,
                        focusNode: _clientFocusNode,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Rechercher par nom, prénom ou téléphone...',
                          hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.38)),
                          prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.54)),
                          suffixIcon: _clientSearchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface.withOpacity(0.54)),
                                  onPressed: () {
                                    setState(() {
                                      _clientSearchController.clear();
                                      _clientQuery = '';
                                      _selectedClientId = null;
                                      _showClientSuggestions = false;
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainer,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.dividerColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.dividerColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.colorScheme.tertiary, width: 2)),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _clientQuery = val;
                            _showClientSuggestions = val.isNotEmpty;
                            if (val.isEmpty) _selectedClientId = null;
                          });
                        },
                        onTap: () {
                          setState(() {
                            _showClientSuggestions = _clientSearchController.text.isNotEmpty;
                          });
                        },
                      ),
                      if (_showClientSuggestions && filtered.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          constraints: const BoxConstraints(maxHeight: 220),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.4)),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filtered.length,
                            itemBuilder: (ctx, i) {
                              final c = filtered[i];
                              final isSelected = c.id == _selectedClientId;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedClientId = c.id;
                                    _clientSearchController.text = '${c.prenom} ${c.nom}';
                                    _clientQuery = '';
                                    _showClientSuggestions = false;
                                  });
                                  _clientFocusNode.unfocus();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  color: isSelected ? theme.colorScheme.tertiary.withOpacity(0.15) : Colors.transparent,
                                  child: Text('${c.prenom} ${c.nom} ${c.telephone != null ? "(${c.telephone})" : ""}', style: TextStyle(color: theme.colorScheme.onSurface)),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // 2 & 3. Date et Heure
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16)),
                                Icon(Icons.calendar_today, color: theme.colorScheme.onSurface.withOpacity(0.54), size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Heure', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_selectedTime.format(context), style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16)),
                                Icon(Icons.access_time, color: theme.colorScheme.onSurface.withOpacity(0.54), size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 4. Coiffeur
              Text('Coiffeur', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              coiffeursAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => Text('Erreur: $e'),
                data: (coiffeurs) => DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  ),
                  dropdownColor: theme.colorScheme.surfaceContainer,
                  value: _selectedCoiffeurId,
                  items: coiffeurs.where((c) => c.actif).map((c) => DropdownMenuItem(value: c.id, child: Text('${c.prenom} ${c.nom}'))).toList(),
                  onChanged: (val) => setState(() => _selectedCoiffeurId = val),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Type de coupe
              Text('Type de coupe', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _typeCoupe = 'Classique'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _typeCoupe == 'Classique' ? theme.colorScheme.tertiaryContainer : theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _typeCoupe == 'Classique' ? theme.colorScheme.tertiary : theme.colorScheme.onSurface.withOpacity(0.12)),
                        ),
                        child: Text(
                          'Classique (9 000 FC)',
                          style: TextStyle(
                            color: _typeCoupe == 'Classique' ? theme.colorScheme.onBackground : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _typeCoupe = 'Premium'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _typeCoupe == 'Premium' ? theme.colorScheme.tertiaryContainer : theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _typeCoupe == 'Premium' ? theme.colorScheme.tertiary : theme.colorScheme.onSurface.withOpacity(0.12)),
                        ),
                        child: Text(
                          'Premium (12 000 FC)',
                          style: TextStyle(
                            color: _typeCoupe == 'Premium' ? theme.colorScheme.onBackground : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 6. Note
              Text('Note (optionnel)', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Détails...',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainer,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _selectedClientId == null || _selectedCoiffeurId == null ? null : _save,
                    style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.tertiary, foregroundColor: theme.colorScheme.onTertiary),
                    child: const Text('Enregistrer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    final combinedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final rdv = RendezVousCompanion.insert(
      clientId: _selectedClientId!,
      coiffeurId: _selectedCoiffeurId!,
      dateRdv: combinedDate,
      typeCoupe: _typeCoupe,
      note: Value(_noteController.text.isNotEmpty ? toSentenceCase(_noteController.text) : null),
    );

    await ref.read(databaseProvider).creerRendezVous(rdv);
    
    // Refresh list
    ref.invalidate(rendezVousProvider);
    
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
