import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../../models/photo.dart';
import 'photo_event.dart';
import 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final Isar isar;

  PhotoBloc(this.isar) : super(PhotoInitial()) {
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<PhotoState> emit) async {
    try {
      emit(PhotoLoading());
      final photo = event.photo;
      photo.isFavorite = !photo.isFavorite;

      await isar.writeTxn(() async {
        await isar.photos.put(photo);
      });

      emit(PhotoLoaded(photo));
    } catch (e) {
      emit(PhotoError(e.toString()));
    }
  }
}
