import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../providers/settings_provider.dart';
import '../../../providers/color_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _salonNameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isEditingName = false;
  bool _isEditingPassword = false;

  @override
  void dispose() {
    _salonNameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _saveSalonName(WidgetRef ref, var settings) {
    if (_salonNameController.text.isNotEmpty) {
      final updated = settings.copyWith(nomSalon: _salonNameController.text);
      ref.read(settingsProvider.notifier).updateSettings(updated);
      setState(() => _isEditingName = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nom du salon mis à jour')),
      );
    }
  }

  void _savePassword(WidgetRef ref, var settings) {
    final oldSavedPassword = settings.motDePasse;
    if (oldSavedPassword != null && oldSavedPassword.isNotEmpty) {
      if (_oldPasswordController.text != oldSavedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("L'ancien mot de passe est incorrect"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    final newPass = _newPasswordController.text;
    final updated = settings.copyWith(
      motDePasse: newPass.isEmpty ? const Value(null) : Value(newPass),
    );
    ref.read(settingsProvider.notifier).updateSettings(updated);
    setState(() {
      _isEditingPassword = false;
      _oldPasswordController.clear();
      _newPasswordController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mot de passe mis à jour avec succès')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final buttonColorAsync = ref.watch(buttonColorProvider);
    final currentColor = buttonColorAsync.maybeWhen(
      data: (c) => c,
      orElse: () => const Color(0xFF5E54A4),
    );

    return Scaffold(
      body: settingsAsync.when(
        data: (settings) {
          if (!_isEditingName && _salonNameController.text != settings.nomSalon) {
            _salonNameController.text = settings.nomSalon;
          }
          final hasPassword = settings.motDePasse != null && settings.motDePasse!.isNotEmpty;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Paramètres',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 24),

              // === THEME ===
              Card(
                child: ListTile(
                  leading: Icon(Icons.brightness_6),
                  title: Text('Thème de l\'application', style: Theme.of(context).textTheme.titleMedium),
                  subtitle: Text(settings.themeClair ? 'Clair' : 'Sombre', style: Theme.of(context).textTheme.bodyMedium),
                  trailing: Switch(
                    value: settings.themeClair,
                    onChanged: (val) {
                      final updated = settings.copyWith(themeClair: val);
                      ref.read(settingsProvider.notifier).updateSettings(updated);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),

              // === COULEUR DES BOUTONS ===
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.palette),
                          SizedBox(width: 8),
                          Text(
                            'Couleur des boutons',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Choisissez la couleur des boutons principaux du logiciel.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: kAvailableColors.map((colorEntry) {
                          final color = colorEntry['color'] as Color;
                          final label = colorEntry['label'] as String;
                          final isSelected = currentColor.value == color.value;
                          return Tooltip(
                            message: label,
                            child: GestureDetector(
                              onTap: () {
                                ref.read(buttonColorProvider.notifier).setColor(color);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: color.withOpacity(0.6),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          )
                                        ]
                                      : [],
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text('Aperçu : ', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Exemple de bouton'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // === NOM DU SALON ===
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.store),
                          SizedBox(width: 8),
                          Text('Nom de la boutique', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (!_isEditingName)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(settings.nomSalon, style: Theme.of(context).textTheme.titleLarge),
                            TextButton.icon(
                              icon: const Icon(Icons.edit),
                              label: const Text('Modifier'),
                              onPressed: () => setState(() => _isEditingName = true),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _salonNameController,
                                decoration: const InputDecoration(labelText: 'Nouveau nom'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () => _saveSalonName(ref, settings),
                              child: const Text('Enregistrer'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isEditingName = false;
                                  _salonNameController.text = settings.nomSalon;
                                });
                              },
                              child: Text('Annuler'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // === MOT DE PASSE ===
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.security),
                          SizedBox(width: 8),
                          Text('Sécurité (Verrouillage)', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (!_isEditingPassword)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                hasPassword
                                    ? "L'application est protégée par un mot de passe."
                                    : 'Aucun mot de passe défini.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            TextButton.icon(
                              icon: Icon(hasPassword ? Icons.edit : Icons.add),
                              label: Text(hasPassword ? 'Modifier' : 'Ajouter'),
                              onPressed: () => setState(() => _isEditingPassword = true),
                            ),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hasPassword) ...[
                              TextField(
                                controller: _oldPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(labelText: 'Ancien mot de passe'),
                              ),
                              const SizedBox(height: 16),
                            ],
                            TextField(
                              controller: _newPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Nouveau mot de passe',
                                helperText: 'Laissez vide pour supprimer le mot de passe',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditingPassword = false;
                                      _oldPasswordController.clear();
                                      _newPasswordController.clear();
                                    });
                                  },
                                  child: const Text('Annuler'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () => _savePassword(ref, settings),
                                  child: const Text('Enregistrer'),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur : $err')),
      ),
    );
  }
}
