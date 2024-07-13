import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../models/search_history.dart';
import '../widgets/photo_grid.dart';
import '../widgets/search_history_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showHistory = false;
  late Isar isar;

  @override
  void initState() {
    super.initState();
    isar = Isar.getInstance()!;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _showHistory = _searchController.text.isEmpty;
    });
  }

  void _hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _saveSearchQuery(String query) async {
    await isar.writeTxn(() async {
      await isar.searchHistorys.put(
        SearchHistory()
          ..query = query
          ..timestamp = DateTime.now(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _hideKeyboard();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (query) async {
                if (query.isNotEmpty) {
                  await _saveSearchQuery(query);
                  searchBloc.add(SearchPhotos(query));
                  _hideKeyboard();
                  setState(() {
                    _showHistory = false;
                  });
                }
              },
              onTap: () {
                setState(() {
                  _showHistory = true;
                });
              },
            ),
            _showHistory
                ? SearchHistoryList(
                    searchController: _searchController,
                    isar: isar,
                    onSearch: (query) => searchBloc.add(SearchPhotos(query)),
                    hideKeyboard: _hideKeyboard,
                    updateShowHistory: (show) {
                      setState(() {
                        _showHistory = show;
                      });
                    },
                  )
                : _buildSearchResults(searchBloc),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(SearchBloc searchBloc) {
    return Expanded(
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchLoaded) {
            return PhotoGrid(photos: state.photos);
          } else if (state is SearchError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Introduzca un término de búsqueda'));
        },
      ),
    );
  }
}
