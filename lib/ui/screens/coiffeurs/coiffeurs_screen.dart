import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../../providers/coiffeurs_provider.dart';
import '../../../data/database.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../utils/text_utils.dart';

class CoiffeursScreen extends ConsumerWidget {
  const CoiffeursScreen({super.key});

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coiffeursState = ref.watch(coiffeursProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Coiffeurs', style: TextStyle(color: Colors.white)),
        actions: [
          ElevatedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const AddCoiffeurDialog(),
            ),
            icon: const Icon(Icons.content_cut),
            label: const Text('Ajouter un coiffeur'),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: coiffeursState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Erreur: $err')),
          data: (coiffeurs) {
            if (coiffeurs.isEmpty) {
              return const Center(child: Text('Aucun coiffeur enregistré.'));
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.15, // Réduit la hauteur des cartes par rapport à 0.85
              ),
              itemCount: coiffeurs.length,
              itemBuilder: (context, index) {
                final c = coiffeurs[index];
                return Card(
                  child: Stack(
                    children: [
                      // Contenu principal
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Photo
                            if (c.photoPath != null)
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: FileImage(File(c.photoPath!)),
                              )
                            else
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                child: Text(
                                  '${c.prenom.isNotEmpty ? c.prenom[0] : ''}${c.nom.isNotEmpty ? c.nom[0] : ''}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),

                            // Nom complet
                            Text(
                              '${c.prenom} ${c.nom}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Spécialité
                            if (c.specialite != null && c.specialite!.isNotEmpty)
                              Text(
                                c.specialite!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),

                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 6),

                            // Infos supplémentaires — afficher seulement si non null
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (c.telephone != null && c.telephone!.isNotEmpty)
                                      _buildInfoRow(context, Icons.phone, c.telephone!),
                                    if (c.adresse != null && c.adresse!.isNotEmpty)
                                      _buildInfoRow(context, Icons.location_on, c.adresse!),
                                    if (c.nationalite != null && c.nationalite!.isNotEmpty)
                                      _buildInfoRow(context, Icons.flag, c.nationalite!),
                                    if (c.lieuNaissance != null && c.lieuNaissance!.isNotEmpty)
                                      _buildInfoRow(context, Icons.place, c.lieuNaissance!),
                                    if (c.dateNaissance != null)
                                      _buildInfoRow(
                                        context,
                                        Icons.cake,
                                        DateFormat('dd/MM/yyyy').format(c.dateNaissance!),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            const Divider(),
                            const SizedBox(height: 6),

                            // Badge statut
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: c.actif ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                c.actif ? 'Actif' : 'Inactif',
                                style: TextStyle(
                                  color: c.actif ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 3 points en haut à droite
                      Positioned(
                        top: 4,
                        right: 4,
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          onSelected: (value) {
                            if (value == 'modifier') {
                              showDialog(
                                context: context,
                                builder: (context) => EditCoiffeurDialog(coiffeur: c),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'modifier',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text('Modifier'),
                                ],
                              ),
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
    );
  }
}

class AddCoiffeurDialog extends ConsumerStatefulWidget {
  const AddCoiffeurDialog({super.key});

  @override
  ConsumerState<AddCoiffeurDialog> createState() => _AddCoiffeurDialogState();
}

class _AddCoiffeurDialogState extends ConsumerState<AddCoiffeurDialog> {
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final telephoneController = TextEditingController();
  final specialiteController = TextEditingController();
  final nationaliteController = TextEditingController();
  final lieuNaissanceController = TextEditingController();
  final adresseController = TextEditingController();
  DateTime? dateNaissance;
  String? photoPath;

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        photoPath = result.files.single.path;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateNaissance = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nouveau Coiffeur'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                  backgroundImage: photoPath != null ? FileImage(File(photoPath!)) : null,
                  child: photoPath == null ? const Icon(Icons.camera_alt, size: 40) : null,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Ajouter une photo', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: TextField(controller: nomController, decoration: const InputDecoration(labelText: 'Nom'))),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: prenomController, decoration: const InputDecoration(labelText: 'Prénom'))),
                ],
              ),
              const SizedBox(height: 16),
              TextField(controller: specialiteController, decoration: const InputDecoration(labelText: 'Spécialité')),
              const SizedBox(height: 16),
              TextField(
                controller: telephoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(controller: adresseController, decoration: const InputDecoration(labelText: 'Adresse')),
              const SizedBox(height: 16),
              TextField(controller: nationaliteController, decoration: const InputDecoration(labelText: 'Nationalité')),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(controller: lieuNaissanceController, decoration: const InputDecoration(labelText: 'Lieu de naissance'))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Date de naissance'),
                        child: Text(dateNaissance == null ? 'Sélectionner' : DateFormat('dd/MM/yyyy').format(dateNaissance!)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.hovered)) return Colors.red;
                return Colors.white;
              }),
              overlayColor: WidgetStateProperty.all(Colors.red.withOpacity(0.08)),
            ),
            child: const Text('Annuler'),
          ),
        ElevatedButton(
          onPressed: () {
            if (nomController.text.isNotEmpty && prenomController.text.isNotEmpty) {
              ref.read(coiffeursProvider.notifier).addCoiffeur(
                nom: toTitleCase(nomController.text),
                prenom: toTitleCase(prenomController.text),
                specialite: toTitleCase(specialiteController.text),
                photoPath: photoPath,
                nationalite: toTitleCase(nationaliteController.text),
                lieuNaissance: toTitleCase(lieuNaissanceController.text),
                dateNaissance: dateNaissance,
                adresse: adresseController.text,
                telephone: telephoneController.text.isEmpty ? null : telephoneController.text,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}

class EditCoiffeurDialog extends ConsumerStatefulWidget {
  final Coiffeur coiffeur;
  const EditCoiffeurDialog({super.key, required this.coiffeur});

  @override
  ConsumerState<EditCoiffeurDialog> createState() => _EditCoiffeurDialogState();
}

class _EditCoiffeurDialogState extends ConsumerState<EditCoiffeurDialog> {
  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController telephoneController;
  late TextEditingController specialiteController;
  late TextEditingController nationaliteController;
  late TextEditingController lieuNaissanceController;
  late TextEditingController adresseController;
  DateTime? dateNaissance;
  String? photoPath;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.coiffeur.nom);
    prenomController = TextEditingController(text: widget.coiffeur.prenom);
    telephoneController = TextEditingController(text: widget.coiffeur.telephone ?? '');
    specialiteController = TextEditingController(text: widget.coiffeur.specialite ?? '');
    nationaliteController = TextEditingController(text: widget.coiffeur.nationalite ?? '');
    lieuNaissanceController = TextEditingController(text: widget.coiffeur.lieuNaissance ?? '');
    adresseController = TextEditingController(text: widget.coiffeur.adresse ?? '');
    dateNaissance = widget.coiffeur.dateNaissance;
    photoPath = widget.coiffeur.photoPath;
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        photoPath = result.files.single.path;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateNaissance ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateNaissance = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modifier Coiffeur'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                  backgroundImage: photoPath != null ? FileImage(File(photoPath!)) : null,
                  child: photoPath == null ? const Icon(Icons.camera_alt, size: 40) : null,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Changer la photo', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: TextField(controller: nomController, decoration: const InputDecoration(labelText: 'Nom'))),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: prenomController, decoration: const InputDecoration(labelText: 'Prénom'))),
                ],
              ),
              const SizedBox(height: 16),
              TextField(controller: specialiteController, decoration: const InputDecoration(labelText: 'Spécialité')),
              const SizedBox(height: 16),
              TextField(
                controller: telephoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(controller: adresseController, decoration: const InputDecoration(labelText: 'Adresse')),
              const SizedBox(height: 16),
              TextField(controller: nationaliteController, decoration: const InputDecoration(labelText: 'Nationalité')),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(controller: lieuNaissanceController, decoration: const InputDecoration(labelText: 'Lieu de naissance'))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Date de naissance'),
                        child: Text(dateNaissance == null ? 'Sélectionner' : DateFormat('dd/MM/yyyy').format(dateNaissance!)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.hovered)) return Colors.red;
                return Colors.white;
              }),
              overlayColor: WidgetStateProperty.all(Colors.red.withOpacity(0.08)),
            ),
            child: const Text('Annuler'),
          ),
        ElevatedButton(
          onPressed: () {
            if (nomController.text.isNotEmpty && prenomController.text.isNotEmpty) {
              final updated = widget.coiffeur.copyWith(
                nom: toTitleCase(nomController.text),
                prenom: toTitleCase(prenomController.text),
                specialite: specialiteController.text.isEmpty ? const Value(null) : Value(toTitleCase(specialiteController.text)),
                photoPath: photoPath == null ? const Value(null) : Value(photoPath),
                nationalite: nationaliteController.text.isEmpty ? const Value(null) : Value(toTitleCase(nationaliteController.text)),
                lieuNaissance: lieuNaissanceController.text.isEmpty ? const Value(null) : Value(toTitleCase(lieuNaissanceController.text)),
                dateNaissance: dateNaissance == null ? const Value(null) : Value(dateNaissance),
                adresse: adresseController.text.isEmpty ? const Value(null) : Value(adresseController.text),
                telephone: telephoneController.text.isEmpty ? const Value(null) : Value(telephoneController.text),
              );
              ref.read(coiffeursProvider.notifier).updateCoiffeur(updated);
              Navigator.pop(context);
            }
          },
          child: const Text('Mettre à jour'),
        ),
      ],
    );
  }
}
