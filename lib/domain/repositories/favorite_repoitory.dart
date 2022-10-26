import 'package:news_app_test/domain/entities/article.dart';

abstract class FavoriteRepository {
  Future<List<Article>> getFavoriteArticles();
  Future<void> setFavoriteArticle(Article article);
}
