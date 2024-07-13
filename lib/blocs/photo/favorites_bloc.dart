import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../../models/photo.dart';
import 'photo_event.dart';
import 'photo_state.dart';

class FavoritesBloc extends Bloc<PhotoEvent, PhotoState> {
  final Isar isar;

  FavoritesBloc(this.isar) : super(PhotoInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<PhotoState> emit) async {
    try {
      emit(PhotoLoading());
      final favorites = await isar.photos.filter().isFavoriteEqualTo(true).findAll();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(PhotoError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<PhotoState> emit) async {
    try {
      final photo = event.photo;
      photo.isFavorite = !photo.isFavorite;

      await isar.writeTxn(() async {
        await isar.photos.put(photo);
      });

      add(LoadFavorites());
    } catch (e) {
      emit(PhotoError(e.toString()));
    }
  }
}
