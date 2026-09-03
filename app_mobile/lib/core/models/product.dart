class Product {
  final String id;
  final String barcode;
  final String name;
  final String? brand;
  final String? categoryId;
  final String? imageUrl;
  final int? daysAfterOpening;
  final String source;

  Product({
    required this.id,
    required this.barcode,
    required this.name,
    this.brand,
    this.categoryId,
    this.imageUrl,
    this.daysAfterOpening,
    required this.source,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        barcode: json['barcode'] as String,
        name: json['name'] as String,
        brand: json['brand'] as String?,
        categoryId: json['categoryId'] as String?,
        imageUrl: json['imageUrl'] as String?,
        daysAfterOpening: json['daysAfterOpening'] as int?,
        source: json['source'] as String,
      );
}
