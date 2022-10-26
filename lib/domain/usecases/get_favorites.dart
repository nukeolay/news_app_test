import 'dart:developer';

import 'package:news_app_test/domain/entities/article.dart';
import 'package:news_app_test/domain/repositories/favorite_repoitory.dart';

class GetFavorites {
  final FavoriteRepository _favoriteRepository;

  const GetFavorites({
    required FavoriteRepository favoriteRepository,
  }) : _favoriteRepository = favoriteRepository;

  Future<List<Article>> call() async {
    final result = await _favoriteRepository.getFavoriteArticles();
    log('-----${result.runtimeType}');
    return result;
  }
}
