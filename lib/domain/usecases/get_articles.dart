import 'dart:developer';

import 'package:news_app_test/domain/entities/article.dart';
import 'package:news_app_test/domain/repositories/articles_repoitory.dart';
import 'package:news_app_test/domain/repositories/favorite_repoitory.dart';

class GetArticles {
  final ArticlesRepository _articlesRepository;
  final FavoriteRepository
      _favoriteRepository; // TODO проверять наличие статьи в избранном и возвращать ее

  const GetArticles({
    required ArticlesRepository articlesRepository,
    required FavoriteRepository favoriteRepository,
  })  : _articlesRepository = articlesRepository,
        _favoriteRepository = favoriteRepository;

  Future<List<Article>> call(
      {required NewsType newsType, required int page}) async {
    late final List<Article> remoteArticles;
    if (newsType == NewsType.all) {
      remoteArticles = await _articlesRepository.getAllArticles(page);
    } else {
      remoteArticles = await _articlesRepository.getTopArticles(page);
    }
    final favoriteArticles = await _favoriteRepository.getFavoriteArticles();
    final List<Article> resultArticles = [];
    for (var remoteArticle in remoteArticles) {
      if (favoriteArticles.contains(remoteArticle)) {
        resultArticles.add(remoteArticle.copyWith(isFavorite: true));
      } else {
        resultArticles.add(remoteArticle);
      }
    }
    return resultArticles;
  }
}

enum NewsType { top, all }
