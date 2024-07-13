import 'package:equatable/equatable.dart';
import '../../models/photo.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object> get props => [];
}

class ToggleFavorite extends PhotoEvent {
  final Photo photo;

  const ToggleFavorite(this.photo);

  @override
  List<Object> get props => [photo];
}

class LoadFavorites extends PhotoEvent {}
