class VideoModel {
    String iso6391;
    String iso31661;
    String name;
    String key;
    String site;
    int size;
    String type;
    bool official;
    DateTime publishedAt;
    String id;

    VideoModel({
        required this.iso6391,
        required this.iso31661,
        required this.name,
        required this.key,
        required this.site,
        required this.size,
        required this.type,
        required this.official,
        required this.publishedAt,
        required this.id,
    });

factory VideoModel.fromJson(Map<String, dynamic> json) {
  return VideoModel(
    iso6391: json['iso_639_1'] ?? '',
    iso31661: json['iso_3166_1'] ?? '',
    name: json['name'] ?? '',
    key: json['key'] ?? '',
    site: json['site'] ?? '',
    size: json['size'] ?? 0,
    type: json['type'] ?? '',
    official: json['official'] ?? false,
    publishedAt: json['published_at'] != null
        ? DateTime.parse(json['published_at'])
        : DateTime.now(),
    id: json['id'] ?? '',
  );
}
}