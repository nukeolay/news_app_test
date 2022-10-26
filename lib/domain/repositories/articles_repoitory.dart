import 'package:news_app_test/domain/entities/article.dart';

abstract class ArticlesRepository {
  Future<List<Article>> getTopArticles(int page);
  Future<List<Article>> getAllArticles(int page);
}
