import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../core/models/shopping_list_item.dart';
import '../l10n/app_localizations.dart';
import 'shopping_list_repository.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  late final ShoppingListRepository _repository;
  late Future<List<ShoppingListItem>> _future;

  @override
  void initState() {
    super.initState();
    _repository = ShoppingListRepository(context.read<AuthService>().apiClient);
    _future = _repository.list();
  }

  // Corpo a blocco: vedi commento in inventory_list_page.dart._reload().
  void _reload() {
    setState(() {
      _future = _repository.list();
    });
  }

  Future<void> _addDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final unitController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addToShoppingList),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, autofocus: true, decoration: InputDecoration(labelText: l10n.itemName)),
            Row(children: [
              Expanded(child: TextField(controller: quantityController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.fieldQuantity))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: unitController, decoration: InputDecoration(labelText: l10n.fieldUnit))),
            ]),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.save)),
        ],
      ),
    );
    if (result == true && nameController.text.trim().isNotEmpty) {
      await _repository.create(
        customName: nameController.text.trim(),
        quantity: double.tryParse(quantityController.text),
        unit: unitController.text.trim().isEmpty ? null : unitController.text.trim(),
      );
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navShoppingList)),
      body: FutureBuilder<List<ShoppingListItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text(l10n.shoppingListEmpty));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                onDismissed: (_) => _repository.delete(item.id),
                child: CheckboxListTile(
                  value: item.purchased,
                  onChanged: (value) async {
                    await _repository.setPurchased(item.id, value ?? false);
                    _reload();
                  },
                  title: Text(
                    item.displayName,
                    style: item.purchased ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey) : null,
                  ),
                  subtitle: item.quantity != null ? Text('${item.quantity} ${item.unit ?? ''}') : null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _addDialog, child: const Icon(Icons.add)),
    );
  }
}
