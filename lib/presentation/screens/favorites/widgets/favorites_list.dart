import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_test/presentation/common/widgets/article_tile.dart';
import 'package:news_app_test/presentation/screens/favorites/bloc/favorites_cubit.dart';
import 'package:news_app_test/presentation/screens/favorites/bloc/favorites_state.dart';
import 'package:news_app_test/domain/entities/article.dart';

class FavoritesList extends StatefulWidget {
  const FavoritesList({super.key});

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      context.read<FavoritesCubit>().loadFavorites();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        List<Article> articles = [];
        if (state is FavoritesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FavoritesLoaded) {
          articles = state.articles;
        }
        if (state is FavoritesError) {
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).errorColor,
              content: Text(state.errorMessage),
            ));
          });
          articles = state.articles;
        }
        if (articles.isEmpty) {
          return const Center(
            child: Text(
              'Вы не добавили в Избранное\nни одной статьи',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) => ArticleTile(
            article: articles[index],
            onSetFavorite: () => context
                .read<FavoritesCubit>()
                .removeFromFavorites(articles[index]),
          ),
          itemCount: articles.length,
        );
      },
    );
  }
}
