import 'package:flutter/material.dart';
import 'package:news_app_test/presentation/screens/favorites/widgets/favorites_list.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: const FavoritesList(),
    );
  }
}
