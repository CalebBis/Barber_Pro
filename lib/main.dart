import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'config/supabase_config.dart';
import 'theme/app_theme.dart';
import 'ui/layout/main_layout.dart';
import 'providers/database_provider.dart';
import 'services/sync_service.dart';
import 'providers/settings_provider.dart';
import 'providers/color_provider.dart';
import 'ui/screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 800),
    minimumSize: Size(1024, 768),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'Benji Coiffure',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Supabase initialization
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  // Initialiser les données de locale pour intl (DateFormat fr_FR, etc.)
  await initializeDateFormatting('fr_FR', null);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Launch background sync on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final db = ref.read(databaseProvider);
      SyncService.syncAll(db);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final buttonColorAsync = ref.watch(buttonColorProvider);

    return settingsAsync.when(
      data: (settings) {
        final hasPassword = settings.motDePasse != null && settings.motDePasse!.isNotEmpty;
        final buttonColor = buttonColorAsync.maybeWhen(
          data: (c) => c,
          orElse: () => AppTheme.defaultButtonColor,
        );
        return MaterialApp(
          title: settings.nomSalon,
          debugShowCheckedModeBanner: false,
          theme: settings.themeClair
              ? AppTheme.lightTheme(buttonColor: buttonColor)
              : AppTheme.darkTheme(buttonColor: buttonColor),
          home: hasPassword ? const LoginScreen() : const MainLayout(),
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (err, stack) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Erreur fatale: $err'))),
      ),
    );
  }
}
