import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/unsplash_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UnsplashRepository unsplashRepository;

  SearchBloc(this.unsplashRepository) : super(SearchInitial()) {
    on<SearchPhotos>(_onSearchPhotos);
    on<LoadRandomPhotos>(_onLoadRandomPhotos);
  }

  void _onSearchPhotos(SearchPhotos event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final photos = await unsplashRepository.searchPhotos(event.query);
      emit(SearchLoaded(photos));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onLoadRandomPhotos(
      LoadRandomPhotos event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final photos = await unsplashRepository.getRandomPhotos(event.count);
      emit(SearchLoaded(photos));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
