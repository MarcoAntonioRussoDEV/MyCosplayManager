import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../core/api_client.dart';
import '../core/models/inventory_item.dart';
import '../l10n/app_localizations.dart';
import 'add_item_page.dart';
import 'inventory_item_detail_page.dart';
import 'inventory_repository.dart';

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  late final InventoryRepository _repository;
  late Future<List<InventoryItem>> _future;

  @override
  void initState() {
    super.initState();
    _repository = InventoryRepository(context.read<AuthService>().apiClient);
    _future = _repository.listItems();
  }

  // Corpo a blocco obbligatorio: `setState(() => _future = ...)` farebbe ritornare
  // al callback il Future dell'assegnazione (non void) — Flutter lo rifiuta con
  // un'eccezione PRIMA di segnare il widget da ricostruire, quindi il fetch parte
  // (i dati nuovi arrivano) ma la UI resta bloccata sulla build precedente finche'
  // non viene rimontata da zero (es. lougout/login).
  void _reload() {
    setState(() {
      _future = _repository.listItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navInventory)),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<InventoryItem>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              final message = snapshot.error is ApiException ? (snapshot.error as ApiException).message : l10n.errorGeneric;
              return _ErrorView(message: message, onRetry: _reload);
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: Center(child: Text(l10n.inventoryEmpty, textAlign: TextAlign.center)),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => _InventoryTile(
                item: items[index],
                onTap: () async {
                  final changed = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(builder: (_) => InventoryItemDetailPage(item: items[index])),
                  );
                  if (changed == true) _reload();
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddItemPage()),
          );
          if (created == true) _reload();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _InventoryTile extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onTap;

  const _InventoryTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final expiry = item.expiryDate;
    Color? expiryColor;
    if (expiry != null && item.status != InventoryItemStatus.consumed && item.status != InventoryItemStatus.discarded) {
      final daysLeft = expiry.difference(DateTime.now()).inDays;
      if (daysLeft < 0) {
        expiryColor = Colors.red;
      } else if (daysLeft <= 7) {
        expiryColor = Colors.orange;
      }
    }

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(child: Icon(_statusIcon(item.status))),
      title: Text(item.product.name),
      subtitle: Text([
        '${item.quantity} ${item.unit}',
        if (item.locationText != null && item.locationText!.isNotEmpty) item.locationText!,
        if (expiry != null) _formatDate(expiry),
      ].join(' · ')),
      trailing: expiryColor != null ? Icon(Icons.warning_amber_rounded, color: expiryColor) : null,
    );
  }

  IconData _statusIcon(InventoryItemStatus status) {
    switch (status) {
      case InventoryItemStatus.opened:
        return Icons.lock_open;
      case InventoryItemStatus.consumed:
        return Icons.check_circle_outline;
      case InventoryItemStatus.discarded:
        return Icons.delete_outline;
      case InventoryItemStatus.sealed_:
        return Icons.lock_outline;
    }
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
