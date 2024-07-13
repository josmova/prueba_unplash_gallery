import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/category/category_bloc.dart';
import 'blocs/photo/photo_bloc.dart';
import 'blocs/photo/favorites_bloc.dart';
import 'repositories/unsplash_repository.dart';
import 'screens/home_screen.dart';
import 'screens/category_photos_screen.dart';
import 'screens/category_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/photo_detail_screen.dart';
import 'screens/search_screen.dart';
import 'models/search_history.dart';
import 'models/photo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [SearchHistorySchema, PhotoSchema],
    directory: dir.path,
  );
  runApp(UnsplashApp(isar: isar));
}

class UnsplashApp extends StatelessWidget {
  final Isar isar;

  const UnsplashApp({Key? key, required this.isar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UnsplashRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => SearchBloc(
                  RepositoryProvider.of<UnsplashRepository>(context))),
          BlocProvider(
              create: (context) => CategoryBloc(
                  RepositoryProvider.of<UnsplashRepository>(context))),
          BlocProvider(create: (context) => PhotoBloc(isar)),
          BlocProvider(create: (context) => FavoritesBloc(isar)),
        ],
        child: MaterialApp(
          title: 'Unsplash App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MainScreen(),
          routes: {
            '/category_photos': (context) => CategoryPhotosScreen(
                  category:
                      ModalRoute.of(context)!.settings.arguments as String,
                ),
            '/photo_details': (context) => PhotoDetailScreen(
                  photo: ModalRoute.of(context)!.settings.arguments as Photo,
                ),
            '/search': (context) => const SearchScreen(),
          },
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const FavoritesScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
