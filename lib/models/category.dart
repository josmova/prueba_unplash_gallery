import 'package:isar/isar.dart';

part 'category.g.dart';

@Collection()
class Category {
  Id id = Isar.autoIncrement;
  late String title;
  late String imageUrl;
  late String coverPhotoUrl;

  Category(
      {required this.title,
      required this.imageUrl,
      required this.coverPhotoUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'] ?? 'No Title',
      imageUrl: json['imageUrl'] ?? '',
      coverPhotoUrl: json['cover_photo']['urls']['regular'] ?? '',
    );
  }
}
