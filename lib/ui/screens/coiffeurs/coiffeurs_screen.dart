import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../../providers/coiffeurs_provider.dart';
import '../../../data/database.dart';
import 'package:drift/drift.dart' hide Column;

class CoiffeursScreen extends ConsumerWidget {
  const CoiffeursScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coiffeursState = ref.watch(coiffeursProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Coiffeurs'),
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
                childAspectRatio: 1.5,
              ),
              itemCount: coiffeurs.length,
              itemBuilder: (context, index) {
                final c = coiffeurs[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (c.photoPath != null)
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: FileImage(File(c.photoPath!)),
                          )
                        else
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: c.actif ? Theme.of(context).primaryColor : Colors.grey,
                            child: Icon(Icons.person, size: 24, color: Theme.of(context).colorScheme.onBackground),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          '${c.prenom} ${c.nom}',
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          c.specialite ?? 'Generaliste',
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (c.nationalite != null)
                          Text(c.nationalite!, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: c.actif ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                c.actif ? 'Actif' : 'Inactif',
                                style: TextStyle(color: c.actif ? Colors.green : Colors.red, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditCoiffeurDialog(coiffeur: c),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
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
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        ElevatedButton(
          onPressed: () {
            if (nomController.text.isNotEmpty && prenomController.text.isNotEmpty) {
              ref.read(coiffeursProvider.notifier).addCoiffeur(
                nom: nomController.text,
                prenom: prenomController.text,
                specialite: specialiteController.text,
                photoPath: photoPath,
                nationalite: nationaliteController.text,
                lieuNaissance: lieuNaissanceController.text,
                dateNaissance: dateNaissance,
                adresse: adresseController.text,
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
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        ElevatedButton(
          onPressed: () {
            if (nomController.text.isNotEmpty && prenomController.text.isNotEmpty) {
              final updated = widget.coiffeur.copyWith(
                nom: nomController.text,
                prenom: prenomController.text,
                specialite: specialiteController.text.isEmpty ? const Value(null) : Value(specialiteController.text),
                photoPath: photoPath == null ? const Value(null) : Value(photoPath),
                nationalite: nationaliteController.text.isEmpty ? const Value(null) : Value(nationaliteController.text),
                lieuNaissance: lieuNaissanceController.text.isEmpty ? const Value(null) : Value(lieuNaissanceController.text),
                dateNaissance: dateNaissance == null ? const Value(null) : Value(dateNaissance),
                adresse: adresseController.text.isEmpty ? const Value(null) : Value(adresseController.text),
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
