class Category {
  final String id;
  final String code;
  final String nameIt;
  final String nameEn;
  final String nameEs;
  final String nameFr;

  Category({
    required this.id,
    required this.code,
    required this.nameIt,
    required this.nameEn,
    required this.nameEs,
    required this.nameFr,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        code: json['code'] as String,
        nameIt: json['nameIt'] as String,
        nameEn: json['nameEn'] as String,
        nameEs: json['nameEs'] as String,
        nameFr: json['nameFr'] as String,
      );

  /// Nome nella lingua attiva: il backend restituisce tutte le traduzioni insieme,
  /// e' il client a scegliere quale mostrare in base al locale corrente.
  String nameFor(String languageCode) {
    switch (languageCode) {
      case 'en':
        return nameEn;
      case 'es':
        return nameEs;
      case 'fr':
        return nameFr;
      default:
        return nameIt;
    }
  }
}
