class CategoryPriceRange {
  final double? min;
  final double? max;
  final double? avg;

  CategoryPriceRange({this.min, this.max, this.avg});

  bool get hasData => min != null && max != null;

  factory CategoryPriceRange.fromJson(Map<String, dynamic> json) => CategoryPriceRange(
        min: (json['min'] as num?)?.toDouble(),
        max: (json['max'] as num?)?.toDouble(),
        avg: (json['avg'] as num?)?.toDouble(),
      );
}
