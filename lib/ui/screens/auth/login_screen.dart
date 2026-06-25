import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../layout/main_layout.dart';
import '../../../providers/settings_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _passwordController = TextEditingController();
  bool _hasError = false;

  void _submit(String expectedPassword) {
    if (_passwordController.text == expectedPassword) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainLayout()),
      );
    } else {
      setState(() {
        _hasError = true;
      });
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      body: Center(
        child: settingsAsync.when(
          data: (settings) {
            final expectedPassword = settings.motDePasse;
            if (expectedPassword == null || expectedPassword.isEmpty) {
              // Si pas de mot de passe, on redirige tout de suite (ne devrait pas arriver souvent ici, mais sécurité)
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainLayout()),
                );
              });
              return const CircularProgressIndicator();
            }

            return SizedBox(
              width: 350,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Icon(Icons.lock, size: 48, color: Colors.orange),
                    SizedBox(height: 16),
                    Text(
                      settings.nomSalon,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    const Text('Veuillez entrer le mot de passe pour accéder au logiciel.'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        errorText: _hasError ? 'Mot de passe incorrect' : null,
                      ),
                      onSubmitted: (_) => _submit(expectedPassword),
                    ),
                    const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _submit(expectedPassword),
                        child: const Text('Déverrouiller'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Erreur: $err'),
        ),
      ),
    );
  }
}
