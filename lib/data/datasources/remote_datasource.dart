import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:news_app_test/core/constants/api.dart';
import 'package:news_app_test/core/errors/exceptions.dart';
import 'package:news_app_test/data/models/article_model.dart';

abstract class RemoteDataSource {
  Future<List<ArticleModel>> fetchTopArticles(int page);
  Future<List<ArticleModel>> fetchAllArticles(int page);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client _client;

  const RemoteDataSourceImpl(http.Client client) : _client = client;

  @override
  Future<List<ArticleModel>> fetchTopArticles(int page) =>
      _fetchArticles('${ApiConstants.topNewsUrl}&page=$page');

  @override
  Future<List<ArticleModel>> fetchAllArticles(int page) =>
      _fetchArticles('${ApiConstants.allNewsUrl}&page=$page');

  Future<List<ArticleModel>> _fetchArticles(String url) async {
    log(url);
    final response = await _client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    try {
      if (response.statusCode == 200) {
        final articles = json.decode(response.body);
        return (articles['articles'] as List)
            .map((article) => ArticleModel.fromJson(article))
            .toList();
      } else {
        throw RemoteDataSourceException(
            errorMessage: 'bad response code: ${response.statusCode}');
      }
    } catch (error) {
      throw RemoteDataSourceException(errorMessage: '$error');
    }
  }
}
