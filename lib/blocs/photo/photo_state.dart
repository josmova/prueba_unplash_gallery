import '../../models/photo.dart';

abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final Photo photo;

  PhotoLoaded(this.photo);
}

class FavoritesLoaded extends PhotoState {
  final List<Photo> favorites;

  FavoritesLoaded(this.favorites);
}

class PhotoError extends PhotoState {
  final String message;

  PhotoError(this.message);
}
