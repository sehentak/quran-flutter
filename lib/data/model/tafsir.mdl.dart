class TafsirMdl {
  final String? wajiz;
  final String? tahlili;
  final String? introSurah;
  final String? kosakata;

  const TafsirMdl({
    required this.wajiz, required this.tahlili,
    required this.introSurah, required this.kosakata
  });

  factory TafsirMdl.fromJson(Map<String, dynamic> json) => TafsirMdl(
    wajiz: json['wajiz'],
    tahlili: json['tahlili'],
    introSurah: json['intro_surah'],
    kosakata: json['kosakata']
  );

  Map<String, dynamic> toJson(int ayahId, [int? id]) => {
    'id': id,
    'ayah_id': ayahId,
    'wajiz': wajiz,
    'tahlili': tahlili,
    'intro_surah': introSurah,
    'kosakata': kosakata
  };
}