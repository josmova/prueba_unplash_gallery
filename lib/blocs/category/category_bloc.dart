import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/unsplash_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final UnsplashRepository unsplashRepository;

  CategoryBloc(this.unsplashRepository) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  void _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await unsplashRepository.getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
