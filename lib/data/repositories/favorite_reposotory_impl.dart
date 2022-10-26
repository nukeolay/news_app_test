import 'package:news_app_test/core/errors/exceptions.dart';
import 'package:news_app_test/data/datasources/local_datasource.dart';
import 'package:news_app_test/data/models/article_model.dart';
import 'package:news_app_test/domain/entities/article.dart';
import 'package:news_app_test/domain/repositories/favorite_repoitory.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final LocalDataSource _localDataSource;

  const FavoriteRepositoryImpl({
    required LocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<List<Article>> getFavoriteArticles() async {
    try {
      final articles = await _localDataSource.load();
      return articles;
    } catch (error) {
      throw LocalDataSourceException(errorMessage: error.toString());
    }
  }

  @override
  Future<void> setFavoriteArticle(Article newArticle) async {
    try {
      final List<Article> articles = await _localDataSource.load();
      final storedArticleIndex =
          articles.indexWhere((article) => article.url == newArticle.url);
      if (storedArticleIndex == -1) {
        // add new favorite article
        final favoriteArticle = ArticleModel(
          // TODO исправить на copyWith
          isFavorite: true,
          author: newArticle.author,
          content: newArticle.content,
          description: newArticle.description,
          publishedAt: newArticle.publishedAt,
          source: newArticle.source,
          title: newArticle.title,
          url: newArticle.url,
          urlToImage: newArticle.urlToImage,
        );
        articles.add(favoriteArticle);
        await _localDataSource.saveArticles(articles: articles);
      } else {
        // remove favorite article
        articles.removeAt(storedArticleIndex);
        await _localDataSource.saveArticles(articles: articles);
      }
    } catch (error) {
      throw LocalDataSourceException(errorMessage: error.toString());
    }
  }
}
