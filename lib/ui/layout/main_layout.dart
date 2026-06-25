import 'package:flutter/material.dart';

// Placeholder imports for screens
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/payment/payment_screen.dart';
import '../screens/clients/clients_screen.dart';
import '../screens/coiffeurs/coiffeurs_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/settings/settings_screen.dart';
import '../../services/sync_service.dart';
import '../../providers/settings_provider.dart';

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
    ClientsScreen(),
    CoiffeursScreen(),
    InventoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final nomSalon = settingsAsync.maybeWhen(
      data: (s) => s.nomSalon,
      orElse: () => 'Benji Coiffure',
    );
    final themeClair = settingsAsync.maybeWhen(
      data: (s) => s.themeClair,
      orElse: () => false,
    );
    final unselectedColor = themeClair ? Theme.of(context).colorScheme.onSurface.withOpacity(0.54) : Theme.of(context).colorScheme.onSurface.withOpacity(0.54);
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selectedIndex < 5 ? _selectedIndex : null,
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
                        FutureBuilder<bool>(
                          future: SyncService.isConnected(),
                          builder: (context, snapshot) {
                            final isConnected = snapshot.data ?? false;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isConnected ? Colors.green : Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isConnected ? 'En ligne' : 'Hors ligne',
                                  style: TextStyle(color: unselectedColor),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 5; // Index de SettingsScreen
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings,
                                color: _selectedIndex == 5 ? Theme.of(context).primaryColor : unselectedColor,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Paramètres',
                                style: TextStyle(
                                  color: _selectedIndex == 5 ? Theme.of(context).primaryColor : unselectedColor,
                                  fontWeight: _selectedIndex == 5 ? FontWeight.bold : FontWeight.normal,
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
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.payment_outlined),
                selectedIcon: Icon(Icons.payment),
                label: Text('Paiement'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Clients'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.content_cut_outlined),
                selectedIcon: Icon(Icons.content_cut),
                label: Text('Coiffeurs'),
              ),
              NavigationRailDestination(
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
