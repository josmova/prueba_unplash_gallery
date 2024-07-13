import 'package:isar/isar.dart';

part 'photo.g.dart';

@collection
class Photo {
  Id id = Isar.autoIncrement;
  late String title;
  late String thumbnailUrl;
  late String fullImageUrl;
  late int width;
  late int height;
  late bool isFavorite;

  Photo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.fullImageUrl,
    required this.width,
    required this.height,
    this.isFavorite = false, 
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['description'] ?? 'No Title',
      thumbnailUrl: json['urls']['thumb'],
      fullImageUrl: json['urls']['full'],
      width: json['width'],
      height: json['height'],
      isFavorite: json['isFavorite'] ?? false, 
    );
  }
}
