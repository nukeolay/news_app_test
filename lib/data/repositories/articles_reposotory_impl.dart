import 'package:news_app_test/core/errors/exceptions.dart';
import 'package:news_app_test/data/datasources/remote_datasource.dart';
import 'package:news_app_test/data/models/article_model.dart';
import 'package:news_app_test/data/platform/connection_cheker.dart';
import 'package:news_app_test/domain/entities/article.dart';
import 'package:news_app_test/domain/repositories/articles_repoitory.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final RemoteDataSource _remoteDataSource;
  final ConnectionCheker _connectionCheker;

  const ArticlesRepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required ConnectionCheker connectionCheker,
  })  : _remoteDataSource = remoteDataSource,
        _connectionCheker = connectionCheker;

  @override
  Future<List<Article>> getAllArticles(int page) async {
    return await _getArticles(() {
      return _remoteDataSource.fetchAllArticles(page);
    });
  }

  @override
  Future<List<Article>> getTopArticles(int page) async {
    return await _getArticles(() {
      return _remoteDataSource.fetchTopArticles(page);
    });
  }

  Future<List<ArticleModel>> _getArticles(
      Future<List<ArticleModel>> Function() fetchArticles) async {
    if (await _connectionCheker.isAvailable) {
      try {
        final articles = await fetchArticles();
        return articles;
      } catch (error) {
        throw RemoteDataSourceException(errorMessage: error.toString());
      }
    } else {
      throw const NetworkConnectionException();
    }
  }
}
