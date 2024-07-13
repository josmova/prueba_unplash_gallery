import 'package:flutter/material.dart';
import '../models/photo.dart';
import 'photo_list_item.dart';

class PhotoGrid extends StatelessWidget {
  final List<Photo> photos;
  final Function(Photo)? onPhotoLongPress;

  const PhotoGrid({Key? key, required this.photos, this.onPhotoLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () => onPhotoLongPress?.call(photos[index]),
          child: PhotoListItem(photo: photos[index]),
        );
      },
    );
  }
}
