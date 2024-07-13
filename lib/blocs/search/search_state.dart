import '../../models/photo.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Photo> photos;

  SearchLoaded(this.photos);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
