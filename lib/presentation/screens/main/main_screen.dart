import 'package:flutter/material.dart';
import 'package:news_app_test/presentation/screens/favorites/favorites_screen.dart';
import 'package:news_app_test/presentation/screens/news/news_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _navigationIndex = 0;

  final _screens = const [
    NewsScreen(),
    FavoritesScreen(),
  ];

  void _onNavigationBarPressed(int index) {
    if (index == _navigationIndex) return;
    setState(() {
      _navigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_navigationIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navigationIndex,
        onTap: _onNavigationBarPressed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt,
            ),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark_border,
            ),
            label: 'Закладки',
          ),
        ],
      ),
    );
  }
}
