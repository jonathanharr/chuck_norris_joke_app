import 'package:flutter/material.dart';
import 'package:chuck_norris_joke_app/app_state.dart';
import 'package:chuck_norris_joke_app/pages/favorites.dart';
import 'package:provider/provider.dart';
import 'package:chuck_norris_joke_app/pages/home.dart';
import 'package:chuck_norris_joke_app/pages/query.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TabBarView _tabBarView;
  int _selectedIndex = 0;
  final _pageTitles = <String>["Chuck-Joke", "Query", "Favorites"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    _tabBarView = TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: [
        const HomePage(),
        QueryPage(
          onQueryFunction: () => fetchWithQuery(),
        ),
        const FavoritesPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: GlobalThemeData.lightThemeData(),
      darkTheme: GlobalThemeData.darkThemeData(),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 80,
                title: SizedBox(
                  height: 80,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 80,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://i.pinimg.com/originals/f1/13/7c/f1137c93551394477fa6bca8dfef803d.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          _pageTitles[_selectedIndex],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                  _tabController.animateTo(_selectedIndex);
                });
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.assistant_direction_sharp),
                  label: "Chuck-Joke",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Query',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
              ],
            ),
            body: _tabBarView
          ),
      ),
    );
  }

  fetchWithQuery() {
    _selectedIndex = 0;
    _tabController.animateTo(_selectedIndex);
  }
}

class GlobalThemeData {
  static ThemeData lightThemeData() {
    return ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(241, 91, 35, 100),
          ),
          splashColor: Colors.transparent,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromRGBO(240, 150, 115, 1.0),
              selectedItemColor: Color.fromARGB(255, 242, 224, 169),
              unselectedItemColor: Colors.black87
              ),
          listTileTheme: const ListTileThemeData(
            tileColor: Color(0xFFEFF3F3),
            selectedTileColor: Color(0xFF241E30),
            iconColor: Color(0xFF241E30),
            textColor: Color(0xFF241E30),
          ),
          colorScheme: const ColorScheme(
            primary: Color(0xFF241E30),
            onPrimary: Color.fromARGB(255, 0, 0, 0),
            primaryContainer: Colors.white,
            secondary: Color(0xFFEFF3F3),
            onSecondary: Color(0xFF322942),
            error: Colors.redAccent,
            onError: Colors.white,
            surface: Color(0xFFEFF3F3),
            onSurface: Color(0xFF241E30),
            brightness: Brightness.light,
          ),
          highlightColor: Colors.transparent,
          focusColor: Colors.black.withOpacity(0.12));
  }

  static ThemeData darkThemeData() 
  {
    return ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(18, 18, 18, 1),
          ),
          splashColor: Colors.transparent,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 30, 30, 1),
            selectedItemColor: Color.fromARGB(255, 242, 224, 169),
            unselectedItemColor: Color.fromARGB(255, 200, 200, 200),
          ),
          listTileTheme: const ListTileThemeData(
            tileColor: Color(0xFF1E1E1E),
            selectedTileColor: Color(0xFF3C3C3C),
            iconColor: Color(0xFFEFEFEF),
            textColor: Color(0xFFEFEFEF),
          ),
          colorScheme: const ColorScheme(
            primary: Color(0xFFBB86FC),
            onPrimary: Color(0xFF121212),
            primaryContainer: Color(0xFF3700B3),
            secondary: Color(0xFF03DAC6),
            onSecondary: Color(0xFF121212),
            error: Color(0xFFCF6679),
            onError: Color(0xFF121212),
            surface: Color(0xFF1E1E1E),
            onSurface: Color(0xFFEFEFEF),
            brightness: Brightness.dark,
          ),
          highlightColor: Colors.transparent,
          focusColor: Colors.white.withOpacity(0.12));
  }

}
