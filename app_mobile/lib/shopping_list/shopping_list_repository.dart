import '../core/api_client.dart';
import '../core/models/shopping_list_item.dart';

class ShoppingListRepository {
  final ApiClient _apiClient;

  ShoppingListRepository(this._apiClient);

  Future<List<ShoppingListItem>> list() async {
    final json = await _apiClient.get('/api/shopping-list') as List;
    return json.map((e) => ShoppingListItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ShoppingListItem> create({String? productId, String? customName, double? quantity, String? unit}) async {
    final json = await _apiClient.post('/api/shopping-list', body: {
      if (productId != null) 'productId': productId,
      if (customName != null) 'customName': customName,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
    });
    return ShoppingListItem.fromJson(json as Map<String, dynamic>);
  }

  Future<ShoppingListItem> setPurchased(String id, bool purchased) async {
    final json = await _apiClient.patch('/api/shopping-list/$id/purchased', body: {'purchased': purchased});
    return ShoppingListItem.fromJson(json as Map<String, dynamic>);
  }

  Future<void> delete(String id) => _apiClient.delete('/api/shopping-list/$id');
}
