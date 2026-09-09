class Project {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final double? laborHours;
  final double? laborRatePerHour;

  Project({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.laborHours,
    this.laborRatePerHour,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        imageUrl: json['imageUrl'] as String?,
        laborHours: (json['laborHours'] as num?)?.toDouble(),
        laborRatePerHour: (json['laborRatePerHour'] as num?)?.toDouble(),
      );
}
