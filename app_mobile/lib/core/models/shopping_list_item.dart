import 'product.dart';

class ShoppingListItem {
  final String id;
  final Product? product;
  final String? customName;
  final double? quantity;
  final String? unit;
  final bool purchased;

  ShoppingListItem({
    required this.id,
    this.product,
    this.customName,
    this.quantity,
    this.unit,
    required this.purchased,
  });

  String get displayName => product?.name ?? customName ?? '';

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) => ShoppingListItem(
        id: json['id'] as String,
        product: json['product'] != null ? Product.fromJson(json['product'] as Map<String, dynamic>) : null,
        customName: json['customName'] as String?,
        quantity: (json['quantity'] as num?)?.toDouble(),
        unit: json['unit'] as String?,
        purchased: json['purchased'] as bool,
      );
}
