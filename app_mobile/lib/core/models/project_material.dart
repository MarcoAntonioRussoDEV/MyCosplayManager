import 'category.dart';
import 'product.dart';
import 'project.dart';

class ProjectMaterial {
  final String id;
  final Category? category;
  final Product? product;
  final String? inventoryItemId;
  final String? note;
  final double quantity;
  final String unit;
  final double? price;

  ProjectMaterial({
    required this.id,
    this.category,
    this.product,
    this.inventoryItemId,
    this.note,
    required this.quantity,
    required this.unit,
    this.price,
  });

  factory ProjectMaterial.fromJson(Map<String, dynamic> json) => ProjectMaterial(
        id: json['id'] as String,
        category: json['category'] != null ? Category.fromJson(json['category'] as Map<String, dynamic>) : null,
        product: json['product'] != null ? Product.fromJson(json['product'] as Map<String, dynamic>) : null,
        inventoryItemId: json['inventoryItemId'] as String?,
        note: json['note'] as String?,
        quantity: (json['quantity'] as num).toDouble(),
        unit: json['unit'] as String,
        price: (json['price'] as num?)?.toDouble(),
      );
}

class ProjectDetail {
  final Project project;
  final List<ProjectMaterial> materials;
  final double materialsCost;
  final double laborCost;
  final double totalCost;

  ProjectDetail({
    required this.project,
    required this.materials,
    required this.materialsCost,
    required this.laborCost,
    required this.totalCost,
  });

  factory ProjectDetail.fromJson(Map<String, dynamic> json) => ProjectDetail(
        project: Project.fromJson(json['project'] as Map<String, dynamic>),
        materials: (json['materials'] as List)
            .map((e) => ProjectMaterial.fromJson(e as Map<String, dynamic>))
            .toList(),
        materialsCost: (json['materialsCost'] as num).toDouble(),
        laborCost: (json['laborCost'] as num).toDouble(),
        totalCost: (json['totalCost'] as num).toDouble(),
      );
}
