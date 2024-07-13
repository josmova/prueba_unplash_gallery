import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../screens/photo_detail_screen.dart';

class PhotoListItem extends StatelessWidget {
  final Photo photo;

  const PhotoListItem({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoDetailScreen(photo: photo),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(photo.thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
