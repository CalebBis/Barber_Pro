import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/clients_provider.dart';
import '../../../providers/coiffeurs_provider.dart';
import '../../../providers/visites_provider.dart';
import '../../../data/database.dart';
import '../../../services/pdf_service.dart';
import '../../../providers/settings_provider.dart';
import '../../../utils/text_utils.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  int? _selectedClientId;
  int? _selectedCoiffeurId;
  String _typeCoupe = 'Classique';
  bool _useGratuite = false;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  // Contrôleurs pour la barre de recherche client
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

  final int prixClassique = 9000;
  final int prixPremium = 12000;

  int get _montantActuel {
    if (_useGratuite) return 0;
    return _typeCoupe == 'Classique' ? prixClassique : prixPremium;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsProvider);
    final coiffeursAsync = ref.watch(coiffeursProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final nomSalon = settingsAsync.maybeWhen(data: (s) => s.nomSalon, orElse: () => 'Benji Coiffure');
    final format = NumberFormat.currency(locale: 'fr_FR', symbol: 'FC', decimalDigits: 0);

    Client? selectedClient;
    if (_selectedClientId != null && clientsAsync.asData != null) {
      selectedClient = clientsAsync.asData!.value.firstWhere(
        (c) => c.id == _selectedClientId,
        orElse: () => clientsAsync.asData!.value.first,
      );
    }

    Coiffeur? selectedCoiffeur;
    if (_selectedCoiffeurId != null && coiffeursAsync.asData != null) {
      selectedCoiffeur = coiffeursAsync.asData!.value.firstWhere(
        (c) => c.id == _selectedCoiffeurId,
        orElse: () => coiffeursAsync.asData!.value.first,
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nouveau paiement', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 24),
              
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rechercher un client
                    Text('Rechercher un client', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
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
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                              decoration: InputDecoration(
                                hintText: 'Rechercher par nom, prénom ou téléphone...',
                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38)),
                                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
                                suffixIcon: _clientSearchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
                                        onPressed: () {
                                          setState(() {
                                            _clientSearchController.clear();
                                            _clientQuery = '';
                                            _selectedClientId = null;
                                            _showClientSuggestions = false;
                                            _useGratuite = false;
                                          });
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 2),
                                ),
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
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Theme.of(context).colorScheme.tertiary.withOpacity(0.4)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
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
                                          if (c.gratuitesDisponibles == 0) _useGratuite = false;
                                        });
                                        _clientFocusNode.unfocus();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Theme.of(context).colorScheme.tertiary.withOpacity(0.15)
                                              : Colors.transparent,
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                                              child: Text(
                                                c.prenom.isNotEmpty ? c.prenom[0].toUpperCase() : '?',
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.tertiary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${c.prenom} ${c.nom}',
                                                    style: TextStyle(
                                                      color: Theme.of(context).colorScheme.onSurface,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  if (c.telephone != null && c.telephone!.isNotEmpty)
                                                    Text(
                                                      c.telephone!,
                                                      style: TextStyle(
                                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            if (isSelected)
                                              Icon(Icons.check_circle, color: Theme.of(context).colorScheme.tertiary, size: 18),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            else if (_showClientSuggestions && filtered.isEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.search_off, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38), size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Aucun client trouvé',
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 16),

                    // Progression fidélité
                    if (selectedClient != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${selectedClient.prenom} ${selectedClient.nom} — ${selectedClient.totalCoupes} coupes au total',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Progression fidélité : ${selectedClient.totalCoupes % 4}/4 vers prochaine gratuite',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: List.generate(4, (index) {
                                final isAchieved = index < (selectedClient!.totalCoupes % 4);
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isAchieved ? const Color(0xFFA5E3CD) : Theme.of(context).colorScheme.surfaceContainer,
                                    shape: BoxShape.circle,
                                    border: isAchieved ? null : Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.24)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: isAchieved ? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                    ],

                    // Catégorie de coiffure
                    Text('Catégorie de coiffure', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _typeCoupe = 'Classique'),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _typeCoupe == 'Classique' ? Theme.of(context).colorScheme.tertiaryContainer : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: _typeCoupe == 'Classique' ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Coupe classique',
                                    style: TextStyle(
                                      color: _typeCoupe == 'Classique' ? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    format.format(prixClassique),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _typeCoupe = 'Premium'),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _typeCoupe == 'Premium' ? Theme.of(context).colorScheme.tertiaryContainer : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: _typeCoupe == 'Premium' ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Coupe premium',
                                    style: TextStyle(
                                      color: _typeCoupe == 'Premium' ? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    format.format(prixPremium),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Date and Coiffeur
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
                                      ),
                                      Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54), size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Coiffeur', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              coiffeursAsync.when(
                                loading: () => const CircularProgressIndicator(),
                                error: (e, s) => Text('Erreur: $e'),
                                data: (coiffeurs) => DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surface,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                                    ),
                                  ),
                                  dropdownColor: Theme.of(context).colorScheme.surfaceContainer,
                                  icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
                                  value: _selectedCoiffeurId,
                                  items: coiffeurs.where((c) => c.actif).map((c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text('${c.prenom} ${c.nom}'),
                                  )).toList(),
                                  onChanged: (val) => setState(() => _selectedCoiffeurId = val),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Note
                    Text('Note (optionnel)', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.70), fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Ex: dégradé, barbe...',
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38)),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Coupe gratuite
                    if (selectedClient != null && selectedClient.gratuitesDisponibles > 0) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CheckboxListTile(
                          value: _useGratuite,
                          onChanged: (val) => setState(() => _useGratuite = val ?? false),
                          title: Text(
                            'Utiliser une coupe gratuite (solde : ${selectedClient.gratuitesDisponibles})',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          activeColor: Theme.of(context).colorScheme.tertiary,
                          checkColor: Theme.of(context).colorScheme.onSurface,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],

                    // Bouton Valider
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: (_selectedClientId == null || _selectedCoiffeurId == null) ? null : _validerPaiement,
                        icon: Icon(Icons.print, color: Theme.of(context).colorScheme.onSurface),
                        label: Text('Valider et imprimer la facture', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                          ),
                          disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),

                    // Facture Preview
                    if (selectedClient != null && selectedCoiffeur != null) ...[
                      Center(
                        child: Container(
                          width: 400,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                nomSalon,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Salon de coiffure — Reçu',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54), fontSize: 14),
                              ),
                              SizedBox(height: 24),
                              Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                              const SizedBox(height: 16),
                              _buildReceiptRow('Client', '${selectedClient.prenom} ${selectedClient.nom}'),
                              SizedBox(height: 16),
                              Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                              const SizedBox(height: 16),
                              _buildReceiptRow('Prestation', 'Coupe ${_typeCoupe.toLowerCase()}'),
                              SizedBox(height: 16),
                              Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                              SizedBox(height: 16),
                              _buildReceiptRow('Date', DateFormat('yyyy-MM-dd').format(_selectedDate)),
                              SizedBox(height: 16),
                              Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                              const SizedBox(height: 16),
                              _buildReceiptRow('Coiffeur', '${selectedCoiffeur.prenom} ${selectedCoiffeur.nom}'),
                              SizedBox(height: 16),
                              Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Montant', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(
                                    _useGratuite ? 'GRATUIT' : format.format(_montantActuel),
                                    style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 32),
                              Text(
                                'Merci de votre visite !',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54), fontSize: 15)),
        Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  void _validerPaiement() async {
    if (_selectedClientId == null || _selectedCoiffeurId == null) return;

    final clients = ref.read(clientsProvider).value ?? [];
    final coiffeurs = ref.read(coiffeursProvider).value ?? [];
    
    final client = clients.firstWhere((c) => c.id == _selectedClientId);
    final coiffeur = coiffeurs.firstWhere((c) => c.id == _selectedCoiffeurId);

    await ref.read(visitesProvider.notifier).addVisite(
      client: client,
      coiffeur: coiffeur,
      typeCoupe: _typeCoupe,
      montant: _montantActuel,
      estGratuite: _useGratuite,
      note: toSentenceCase(_noteController.text),
      dateVisite: _selectedDate,
    );

    final mockVisite = Visite(
      id: 0,
      clientId: client.id,
      coiffeurId: coiffeur.id,
      dateVisite: _selectedDate,
      typeCoupe: _typeCoupe,
      montant: _montantActuel,
      estGratuite: _useGratuite,
      note: toSentenceCase(_noteController.text),
    );

    final settings = ref.read(settingsProvider).value;
    final nomSalon = settings?.nomSalon ?? 'Benji Coiffure';

    await PdfService.generateReceipt(
      client: client,
      coiffeur: coiffeur,
      visite: mockVisite,
      salonName: nomSalon,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paiement enregistré et reçu généré !'), backgroundColor: Colors.green),
      );
      setState(() {
        _selectedClientId = null;
        _typeCoupe = 'Classique';
        _useGratuite = false;
        _noteController.clear();
        _selectedDate = DateTime.now();
      });
    }
  }
}
