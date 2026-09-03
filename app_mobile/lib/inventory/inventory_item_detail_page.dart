import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../core/models/inventory_item.dart';
import '../l10n/app_localizations.dart';
import 'inventory_repository.dart';

class InventoryItemDetailPage extends StatefulWidget {
  final InventoryItem item;

  const InventoryItemDetailPage({super.key, required this.item});

  @override
  State<InventoryItemDetailPage> createState() => _InventoryItemDetailPageState();
}

class _InventoryItemDetailPageState extends State<InventoryItemDetailPage> {
  late final InventoryRepository _repository;
  late InventoryItem _item;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _repository = InventoryRepository(context.read<AuthService>().apiClient);
    _item = widget.item;
  }

  Future<void> _changeStatus(InventoryItemStatus status) async {
    setState(() => _busy = true);
    try {
      final updated = await _repository.changeStatus(_item.id, status);
      setState(() => _item = updated);
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.confirmDeleteMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      await _repository.deleteItem(_item.id);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      _showError(e);
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.product.name),
        actions: [
          IconButton(onPressed: _busy ? null : _delete, icon: const Icon(Icons.delete_outline)),
        ],
      ),
      body: AbsorbPointer(
        absorbing: _busy,
        child: Opacity(
          opacity: _busy ? 0.6 : 1,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_item.product.brand != null) _row(l10n.fieldBrand, _item.product.brand!),
              _row(l10n.fieldQuantity, '${_item.quantity} ${_item.unit}'),
              if (_item.price != null) _row(l10n.fieldPrice, '${_item.price} €'),
              if (_item.locationText != null && _item.locationText!.isNotEmpty)
                _row(l10n.fieldLocation, _item.locationText!),
              if (_item.expiryDate != null) _row(l10n.fieldExpiryDate, _item.expiryDate!.toIso8601String().substring(0, 10)),
              if (_item.remainingQuantity != null) _row(l10n.remainingQuantity, '${_item.remainingQuantity}'),
              _row('Barcode', _item.product.barcode),
              const SizedBox(height: 24),
              Text(_statusLabel(l10n, _item.status), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: _statusActions(l10n)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.grey))),
            Expanded(child: Text(value)),
          ],
        ),
      );

  String _statusLabel(AppLocalizations l10n, InventoryItemStatus status) {
    switch (status) {
      case InventoryItemStatus.sealed_:
        return l10n.statusSealed;
      case InventoryItemStatus.opened:
        return l10n.statusOpened;
      case InventoryItemStatus.consumed:
        return l10n.statusConsumed;
      case InventoryItemStatus.discarded:
        return l10n.statusDiscarded;
    }
  }

  List<Widget> _statusActions(AppLocalizations l10n) {
    final actions = <Widget>[];
    if (_item.status == InventoryItemStatus.sealed_) {
      actions.add(FilledButton.icon(
        onPressed: () => _changeStatus(InventoryItemStatus.opened),
        icon: const Icon(Icons.lock_open),
        label: Text(l10n.markOpened),
      ));
    }
    if (_item.status == InventoryItemStatus.sealed_ || _item.status == InventoryItemStatus.opened) {
      actions.add(OutlinedButton.icon(
        onPressed: () => _changeStatus(InventoryItemStatus.consumed),
        icon: const Icon(Icons.check_circle_outline),
        label: Text(l10n.markConsumed),
      ));
      actions.add(OutlinedButton.icon(
        onPressed: () => _changeStatus(InventoryItemStatus.discarded),
        icon: const Icon(Icons.delete_outline),
        label: Text(l10n.markDiscarded),
      ));
    }
    return actions;
  }
}
