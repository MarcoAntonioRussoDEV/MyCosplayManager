import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../core/models/category.dart';
import '../core/models/product.dart';
import '../l10n/app_localizations.dart';
import 'barcode_scan_page.dart';
import 'inventory_repository.dart';

enum _Step { chooseInput, loading, existingProduct, newProduct }

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  late final InventoryRepository _repository;

  _Step _step = _Step.chooseInput;
  String? _barcode;
  Product? _foundProduct;
  List<Category> _categories = [];
  String? _selectedCategoryId;
  bool _saving = false;
  String? _error;

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _daysAfterOpeningController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _unitController = TextEditingController(text: 'pz');
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    _repository = InventoryRepository(context.read<AuthService>().apiClient);
    // Lo scan e' l'unico modo di aggiungere un prodotto (se il barcode non e' a
    // catalogo si passa comunque dalla scheda "nuovo prodotto"): parte subito,
    // niente inserimento manuale del barcode.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scan());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _daysAfterOpeningController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeScanPage()),
    );
    if (code != null) await _lookup(code);
  }

  Future<void> _lookup(String barcode) async {
    setState(() {
      _barcode = barcode;
      _step = _Step.loading;
      _error = null;
    });
    try {
      final product = await _repository.findProductByBarcode(barcode);
      if (product != null) {
        setState(() {
          _foundProduct = product;
          _step = _Step.existingProduct;
        });
      } else {
        _categories = await _repository.listCategories();
        setState(() {
          _nameController.text = '';
          _step = _Step.newProduct;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _step = _Step.chooseInput;
      });
    }
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  Future<void> _saveExistingProduct() async {
    setState(() => _saving = true);
    try {
      await _repository.createItem(
        productId: _foundProduct!.id,
        quantity: double.tryParse(_quantityController.text) ?? 1,
        unit: _unitController.text,
        price: double.tryParse(_priceController.text),
        locationText: _locationController.text,
        expiryDate: _expiryDate,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveNewProduct() async {
    setState(() => _saving = true);
    try {
      final product = await _repository.createProduct(
        barcode: _barcode!,
        name: _nameController.text,
        brand: _brandController.text,
        categoryId: _selectedCategoryId,
        daysAfterOpening: int.tryParse(_daysAfterOpeningController.text),
      );
      await _repository.createItem(
        productId: product.id,
        quantity: double.tryParse(_quantityController.text) ?? 1,
        unit: _unitController.text,
        price: double.tryParse(_priceController.text),
        locationText: _locationController.text,
        expiryDate: _expiryDate,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addItem)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(l10n),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    switch (_step) {
      case _Step.chooseInput:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_error != null) Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
            // Visibile solo se lo scan si apre da solo (vedi initState) e viene
            // annullato (permesso fotocamera negato, o back dalla fotocamera): serve
            // un modo per ritentare.
            FilledButton.icon(onPressed: _scan, icon: const Icon(Icons.qr_code_scanner), label: Text(l10n.scanBarcode)),
          ],
        );
      case _Step.loading:
        return const Center(child: CircularProgressIndicator());
      case _Step.existingProduct:
        return _itemForm(
          l10n,
          header: ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(_foundProduct!.name),
            subtitle: Text(_foundProduct!.brand ?? _barcode ?? ''),
          ),
          onSave: _saveExistingProduct,
        );
      case _Step.newProduct:
        return _itemForm(
          l10n,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.productNotFound, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.fieldName)),
              const SizedBox(height: 8),
              TextField(controller: _brandController, decoration: InputDecoration(labelText: l10n.fieldBrand)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                decoration: InputDecoration(labelText: l10n.fieldCategory),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nameFor(Localizations.localeOf(context).languageCode))))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategoryId = value),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _daysAfterOpeningController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.fieldDaysAfterOpening),
              ),
              const Divider(height: 32),
            ],
          ),
          onSave: _saveNewProduct,
        );
    }
  }

  Widget _itemForm(AppLocalizations l10n, {required Widget header, required VoidCallback onSave}) {
    return ListView(
      children: [
        header,
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: TextField(controller: _quantityController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.fieldQuantity))),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: _unitController, decoration: InputDecoration(labelText: l10n.fieldUnit))),
        ]),
        const SizedBox(height: 8),
        TextField(controller: _priceController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: l10n.fieldPrice)),
        const SizedBox(height: 8),
        TextField(
          controller: _locationController,
          decoration: InputDecoration(labelText: l10n.fieldLocation, prefixIcon: const Icon(Icons.place_outlined)),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.fieldExpiryDate),
          subtitle: Text(_expiryDate == null ? '—' : _expiryDate!.toIso8601String().substring(0, 10)),
          trailing: const Icon(Icons.calendar_today),
          onTap: _pickExpiryDate,
        ),
        const SizedBox(height: 16),
        if (_error != null) Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(_error!, style: const TextStyle(color: Colors.red)),
        ),
        FilledButton(
          onPressed: _saving ? null : onSave,
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.save),
        ),
      ],
    );
  }
}
