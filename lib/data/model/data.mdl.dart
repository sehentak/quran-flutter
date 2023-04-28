class DataMdl<T> {
  final T data;

  const DataMdl({
    required this.data
  });

  factory DataMdl.fromJson(Map<String, dynamic> json) => DataMdl(
    data: json['data']
  );
}