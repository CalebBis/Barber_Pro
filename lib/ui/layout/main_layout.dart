import 'package:flutter/material.dart';

// Placeholder imports for screens
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/payment/payment_screen.dart';
import '../screens/clients/clients_screen.dart';
import '../screens/coiffeurs/coiffeurs_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import '../screens/rendez_vous/rendez_vous_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/settings/settings_screen.dart';
import '../../providers/settings_provider.dart';
import '../../providers/rendez_vous_provider.dart';
import '../../providers/connexion_provider.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    PaymentScreen(),
    RendezVousScreen(),
    ClientsScreen(),
    CoiffeursScreen(),
    InventoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final rdvBadgeAsync = ref.watch(rdvAujourdhuilProvider);
    final rdvBadgeCount = rdvBadgeAsync.value ?? 0;
    final connexionAsync = ref.watch(connexionSupabaseProvider);
    final estConnecte = connexionAsync.maybeWhen(
      data: (v) => v,
      orElse: () => false,
    );
    final nomSalon = settingsAsync.maybeWhen(
      data: (s) => s.nomSalon,
      orElse: () => 'Benji Coiffure',
    );
    final themeClair = settingsAsync.maybeWhen(
      data: (s) => s.themeClair,
      orElse: () => false,
    );
    final unselectedColor = themeClair ? Theme.of(context).colorScheme.onSurface.withOpacity(0.54) : Theme.of(context).colorScheme.onSurface.withOpacity(0.54);
    // Updated: Settings is now index 6
    const int settingsIndex = 6;
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selectedIndex < settingsIndex ? _selectedIndex : null,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            extended: true, // Always expanded on desktop
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            selectedLabelTextStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
            unselectedIconTheme: IconThemeData(color: unselectedColor),
            unselectedLabelTextStyle: TextStyle(color: unselectedColor),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Icon(Icons.cut, size: 48, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8),
                  Text(
                    nomSalon,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Indicateur connexion Supabase (StreamProvider — rafraîchi toutes les 10s)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: estConnecte
                                  ? const Color(0xFF1D9E75)
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              estConnecte ? 'En ligne' : 'Hors ligne',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: unselectedColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = settingsIndex;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings,
                                color: _selectedIndex == settingsIndex ? Theme.of(context).primaryColor : unselectedColor,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Paramètres',
                                style: TextStyle(
                                  color: _selectedIndex == settingsIndex ? Theme.of(context).primaryColor : unselectedColor,
                                  fontWeight: _selectedIndex == settingsIndex ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              ),
            ),
            destinations: [
              const NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.payment_outlined),
                selectedIcon: Icon(Icons.payment),
                label: Text('Paiement'),
              ),
              NavigationRailDestination(
                icon: rdvBadgeCount > 0
                    ? Badge(
                        label: Text('$rdvBadgeCount'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        textColor: Theme.of(context).colorScheme.onError,
                        child: const Icon(Icons.calendar_month_outlined),
                      )
                    : const Icon(Icons.calendar_month_outlined),
                selectedIcon: rdvBadgeCount > 0
                    ? Badge(
                        label: Text('$rdvBadgeCount'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        textColor: Theme.of(context).colorScheme.onError,
                        child: const Icon(Icons.calendar_month),
                      )
                    : const Icon(Icons.calendar_month),
                label: const Text('Rendez-vous'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Clients'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.content_cut_outlined),
                selectedIcon: Icon(Icons.content_cut),
                label: Text('Coiffeurs'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Inventaire'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
          // Main Content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
