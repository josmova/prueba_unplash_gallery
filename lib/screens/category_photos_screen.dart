import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../widgets/photo_grid.dart';

class CategoryPhotosScreen extends StatelessWidget {
  final String category;

  const CategoryPhotosScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SearchBloc>(context).add(SearchPhotos(category));

    return Scaffold(
      appBar: AppBar(
        title: Text('Fotos de $category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchLoaded) {
              return PhotoGrid(photos: state.photos);
            } else if (state is SearchError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Cargando fotos...'));
          },
        ),
      ),
    );
  }
}
