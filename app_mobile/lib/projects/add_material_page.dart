import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../core/api_client.dart';
import '../core/models/category.dart';
import '../core/models/category_price_range.dart';
import '../core/models/inventory_item.dart';
import '../core/models/product.dart';
import '../core/models/project_material.dart';
import '../inventory/inventory_repository.dart';
import '../l10n/app_localizations.dart';
import 'project_repository.dart';

class AddMaterialPage extends StatefulWidget {
  final String projectId;

  const AddMaterialPage({super.key, required this.projectId});

  @override
  State<AddMaterialPage> createState() => _AddMaterialPageState();
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  late final ProjectRepository _projectRepository;
  late final InventoryRepository _inventoryRepository;
  late Future<List<Category>> _categoriesFuture;
  late Future<List<InventoryItem>> _inventoryItemsFuture;

  Category? _selectedCategory;
  Future<CategoryPriceRange>? _priceRangeFuture;

  InventoryItem? _selectedItem;
  Product? _selectedProduct;

  final _noteController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _unitController = TextEditingController();
  final _priceController = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final apiClient = context.read<AuthService>().apiClient;
    _projectRepository = ProjectRepository(apiClient);
    _inventoryRepository = InventoryRepository(apiClient);
    _categoriesFuture = _inventoryRepository.listCategories();
    _inventoryItemsFuture = _inventoryRepository.listItems();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _selectCategory(Category? category) {
    setState(() {
      _selectedCategory = category;
      _selectedItem = null;
      _selectedProduct = null;
      _priceRangeFuture = category != null ? _inventoryRepository.categoryPriceRange(category.id) : null;
    });
  }

  Future<void> _pickProduct() async {
    final category = _selectedCategory;
    if (category == null) return;
    final items = await _inventoryItemsFuture;
    final itemsInCategory = items.where((i) => i.product.categoryId == category.id).toList();
    if (!mounted) return;
    final choice = await Navigator.of(context).push<_ProductChoice>(
      MaterialPageRoute(
        builder: (_) => _ProductPickerPage(
          category: category,
          inventoryItems: itemsInCategory,
          inventoryRepository: _inventoryRepository,
        ),
      ),
    );
    if (choice == null) return;
    setState(() {
      _selectedItem = choice.item;
      _selectedProduct = choice.product;
      if (choice.item != null) {
        _unitController.text = choice.item!.unit;
        _priceController.text = choice.item!.price?.toString() ?? '';
      }
    });
  }

  Future<void> _save() async {
    final category = _selectedCategory;
    if (category == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final detail = await _projectRepository.addMaterial(
        widget.projectId,
        categoryId: category.id,
        productId: _selectedItem?.product.id ?? _selectedProduct?.id,
        inventoryItemId: _selectedItem?.id,
        note: _noteController.text.trim(),
        quantity: double.tryParse(_quantityController.text.replaceAll(',', '.')) ?? 1,
        unit: _unitController.text.trim(),
        price: _priceController.text.trim().isEmpty
            ? null
            : double.tryParse(_priceController.text.replaceAll(',', '.')),
      );
      if (mounted) Navigator.of(context).pop<ProjectDetail>(detail);
    } catch (e) {
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final productName = _selectedItem?.product.name ?? _selectedProduct?.name;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addMaterial)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FutureBuilder<List<Category>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              final categories = snapshot.data ?? [];
              return DropdownButtonFormField<Category>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(labelText: l10n.fieldCategory),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.nameFor(languageCode))))
                    .toList(),
                onChanged: _selectCategory,
              );
            },
          ),
          if (_priceRangeFuture != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: FutureBuilder<CategoryPriceRange>(
                future: _priceRangeFuture,
                builder: (context, snapshot) {
                  final range = snapshot.data;
                  if (range == null || !range.hasData) return const SizedBox.shrink();
                  return Text(
                    '${l10n.priceRangeInCategory}: €${range.min!.toStringAsFixed(2)} - €${range.max!.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
          TextField(controller: _noteController, decoration: InputDecoration(labelText: l10n.fieldNote)),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            enabled: _selectedCategory != null,
            title: Text(l10n.productOptional),
            subtitle: Text(productName ?? l10n.noProductChosen),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectedCategory == null ? null : _pickProduct,
          ),
          const Divider(),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.fieldQuantity),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _unitController, decoration: InputDecoration(labelText: l10n.fieldUnit))),
          ]),
          const SizedBox(height: 8),
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.fieldPrice, helperText: l10n.estimatedFromCategory),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          FilledButton(
            onPressed: _saving || _selectedCategory == null ? null : _save,
            child: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

class _ProductChoice {
  final InventoryItem? item;
  final Product? product;

  const _ProductChoice({this.item, this.product});
}

class _ProductPickerPage extends StatefulWidget {
  final Category category;
  final List<InventoryItem> inventoryItems;
  final InventoryRepository inventoryRepository;

  const _ProductPickerPage({
    required this.category,
    required this.inventoryItems,
    required this.inventoryRepository,
  });

  @override
  State<_ProductPickerPage> createState() => _ProductPickerPageState();
}

class _ProductPickerPageState extends State<_ProductPickerPage> {
  final _searchController = TextEditingController();
  late Future<List<Product>> _catalogFuture;

  @override
  void initState() {
    super.initState();
    _catalogFuture = widget.inventoryRepository.searchProducts('', categoryId: widget.category.id);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runSearch(String query) {
    setState(() {
      _catalogFuture = widget.inventoryRepository.searchProducts(query.trim(), categoryId: widget.category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.nameFor(languageCode))),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.block),
            title: Text(l10n.noProductOption),
            onTap: () => Navigator.of(context).pop(const _ProductChoice()),
          ),
          const Divider(height: 1),
          if (widget.inventoryItems.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.fromInventoryTab, style: Theme.of(context).textTheme.titleSmall),
            ),
            ...widget.inventoryItems.map((item) => ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('${item.quantity} ${item.unit}'),
                  onTap: () => Navigator.of(context).pop(_ProductChoice(item: item)),
                )),
            const Divider(),
          ],
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.searchProductHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: _runSearch,
              onSubmitted: _runSearch,
            ),
          ),
          FutureBuilder<List<Product>>(
            future: _catalogFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final results = snapshot.data ?? [];
              if (results.isEmpty) {
                return Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(l10n.noSearchResults)));
              }
              return Column(
                children: results
                    .map((product) => ListTile(
                          title: Text(product.name),
                          subtitle: product.brand != null ? Text(product.brand!) : null,
                          onTap: () => Navigator.of(context).pop(_ProductChoice(product: product)),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
