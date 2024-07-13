import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:isar/isar.dart';
import '../models/photo.dart';
import '../blocs/photo/photo_bloc.dart';
import '../blocs/photo/photo_event.dart';
import '../blocs/photo/photo_state.dart';

class PhotoDetailScreen extends StatelessWidget {
  final Photo photo;

  const PhotoDetailScreen({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotoBloc(Isar.getInstance()!),
      child: PhotoDetailView(photo: photo),
    );
  }
}

class PhotoDetailView extends StatelessWidget {
  final Photo photo;

  const PhotoDetailView({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(
      builder: (context, state) {
        bool isFavorite = photo.isFavorite;
        if (state is PhotoLoaded) {
          isFavorite = state.photo.isFavorite;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(photo.title),
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: photo.fullImageUrl,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Positioned(
                    top: 16.0,
                    right: 16.0,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        BlocProvider.of<PhotoBloc>(context)
                            .add(ToggleFavorite(photo));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  photo.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Funcionalidad no disponible')),
                        );
                      },
                    ),
                    const SizedBox(width: 16.0),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Funcionalidad no disponible')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
