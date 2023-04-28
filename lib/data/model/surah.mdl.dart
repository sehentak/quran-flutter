class SurahMdl {
  final int id;
  final String arabic;
  final String latin;
  final String transliteration;
  final String translation; // indexed
  final int ayahCount;
  final int page;
  final String location;

  const SurahMdl({
    required this.id, required this.arabic, required this.latin,
    required this.transliteration, required this.translation,
    required this.ayahCount, required this.page, required this.location
  });

  factory SurahMdl.fromJson(Map<String, dynamic> json) => SurahMdl(
      id: json['id'],
      arabic: json['arabic'],
      latin: json['latin'],
      transliteration: json['transliteration'],
      translation: json['translation'],
      ayahCount: json['num_ayah'],
      page: json['page'],
      location: json['location']
  );

  Map<String, dynamic> toJson([bool? isRealId]) => {
    'id': isRealId != null && isRealId == true ? id : null,
    'arabic': arabic.trim(),
    'latin': latin.trim(),
    'transliteration': transliteration,
    'translation': translation.trim(),
    'num_ayah': ayahCount,
    'page': page,
    'location': location
  };
}