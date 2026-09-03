import 'product.dart';

enum InventoryItemStatus { sealed_, opened, consumed, discarded }

InventoryItemStatus statusFromJson(String value) {
  switch (value) {
    case 'OPENED':
      return InventoryItemStatus.opened;
    case 'CONSUMED':
      return InventoryItemStatus.consumed;
    case 'DISCARDED':
      return InventoryItemStatus.discarded;
    default:
      return InventoryItemStatus.sealed_;
  }
}

String statusToJson(InventoryItemStatus status) {
  switch (status) {
    case InventoryItemStatus.opened:
      return 'OPENED';
    case InventoryItemStatus.consumed:
      return 'CONSUMED';
    case InventoryItemStatus.discarded:
      return 'DISCARDED';
    case InventoryItemStatus.sealed_:
      return 'SEALED';
  }
}

class InventoryItem {
  final String id;
  final Product product;
  final double quantity;
  final String unit;
  final double? price;
  final String? locationText;
  final DateTime? expiryDate;
  final InventoryItemStatus status;
  final DateTime? openedAt;
  final double? remainingQuantity;

  InventoryItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unit,
    this.price,
    this.locationText,
    this.expiryDate,
    required this.status,
    this.openedAt,
    this.remainingQuantity,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json['id'] as String,
        product: Product.fromJson(json['product'] as Map<String, dynamic>),
        quantity: (json['quantity'] as num).toDouble(),
        unit: json['unit'] as String,
        price: (json['price'] as num?)?.toDouble(),
        locationText: json['locationText'] as String?,
        expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate'] as String) : null,
        status: statusFromJson(json['status'] as String),
        openedAt: json['openedAt'] != null ? DateTime.parse(json['openedAt'] as String) : null,
        remainingQuantity: (json['remainingQuantity'] as num?)?.toDouble(),
      );
}
