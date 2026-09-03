import 'package:flutter/material.dart';

import '../inventory/inventory_list_page.dart';
import '../l10n/app_localizations.dart';
import '../settings/settings_page.dart';
import '../shopping_list/shopping_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [InventoryListPage(), ShoppingListPage(), SettingsPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.inventory_2_outlined), label: l10n.navInventory),
          NavigationDestination(icon: const Icon(Icons.shopping_cart_outlined), label: l10n.navShoppingList),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: l10n.navSettings),
        ],
      ),
    );
  }
}
