import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../widgets/photo_grid.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../blocs/photo/favorites_bloc.dart';
import '../blocs/photo/photo_event.dart';
import '../blocs/photo/photo_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FavoritesBloc(Isar.getInstance()!)..add(LoadFavorites()),
      child: const FavoritesView(),
    );
  }
}

class FavoritesView extends StatelessWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: BlocBuilder<FavoritesBloc, PhotoState>(
        builder: (context, state) {
          if (state is PhotoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PhotoError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is FavoritesLoaded) {
            final photos = state.favorites;

            if (photos.isEmpty) {
              return const Center(child: Text('Aún no tienes favoritos.'));
            }

            return PhotoGrid(
              photos: photos,
              onPhotoLongPress: (photo) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmDeleteDialog(onConfirm: () {
                      BlocProvider.of<FavoritesBloc>(context)
                          .add(ToggleFavorite(photo));
                    });
                  },
                );
              },
            );
          }

          return const Center(child: Text('Aún no tienes favoritos.'));
        },
      ),
    );
  }
}
