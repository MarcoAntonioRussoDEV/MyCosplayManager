import '../core/api_client.dart';
import '../core/models/category.dart';
import '../core/models/inventory_item.dart';
import '../core/models/product.dart';

class InventoryRepository {
  final ApiClient _apiClient;

  InventoryRepository(this._apiClient);

  Future<List<Category>> listCategories() async {
    final json = await _apiClient.get('/api/categories') as List;
    return json.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Torna null se nessun prodotto e' registrato per questo barcode (404).
  Future<Product?> findProductByBarcode(String barcode) async {
    try {
      final json = await _apiClient.get('/api/products/$barcode');
      return Product.fromJson(json as Map<String, dynamic>);
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<Product> createProduct({
    required String barcode,
    required String name,
    String? brand,
    String? categoryId,
    int? daysAfterOpening,
  }) async {
    final json = await _apiClient.post('/api/products', body: {
      'barcode': barcode,
      'name': name,
      if (brand != null && brand.isNotEmpty) 'brand': brand,
      if (categoryId != null) 'categoryId': categoryId,
      if (daysAfterOpening != null) 'daysAfterOpening': daysAfterOpening,
    });
    return Product.fromJson(json as Map<String, dynamic>);
  }

  Future<List<InventoryItem>> listItems({InventoryItemStatus? status}) async {
    final json = await _apiClient.get('/api/inventory',
        query: status != null ? {'status': statusToJson(status)} : null) as List;
    return json.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<InventoryItem> createItem({
    required String productId,
    required double quantity,
    required String unit,
    double? price,
    String? locationText,
    DateTime? expiryDate,
  }) async {
    final json = await _apiClient.post('/api/inventory', body: {
      'productId': productId,
      'quantity': quantity,
      'unit': unit,
      if (price != null) 'price': price,
      if (locationText != null && locationText.isNotEmpty) 'locationText': locationText,
      if (expiryDate != null) 'expiryDate': _dateOnly(expiryDate),
    });
    return InventoryItem.fromJson(json as Map<String, dynamic>);
  }

  Future<InventoryItem> updateItem({
    required String id,
    required double quantity,
    required String unit,
    double? price,
    String? locationText,
    DateTime? expiryDate,
    double? remainingQuantity,
  }) async {
    final json = await _apiClient.put('/api/inventory/$id', body: {
      'quantity': quantity,
      'unit': unit,
      'price': price,
      'locationText': locationText,
      'expiryDate': expiryDate != null ? _dateOnly(expiryDate) : null,
      'remainingQuantity': remainingQuantity,
    });
    return InventoryItem.fromJson(json as Map<String, dynamic>);
  }

  Future<InventoryItem> changeStatus(String id, InventoryItemStatus status) async {
    final json = await _apiClient.patch('/api/inventory/$id/status', body: {'status': statusToJson(status)});
    return InventoryItem.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteItem(String id) => _apiClient.delete('/api/inventory/$id');

  String _dateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
