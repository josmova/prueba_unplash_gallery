import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchPhotos extends SearchEvent {
  final String query;

  const SearchPhotos(this.query);

  @override
  List<Object> get props => [query];
}

class LoadRandomPhotos extends SearchEvent {
  final int count;

  const LoadRandomPhotos({required this.count});

  @override
  List<Object> get props => [count];
}
