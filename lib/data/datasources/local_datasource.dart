import 'dart:convert';

import 'package:news_app_test/core/errors/exceptions.dart';
import 'package:news_app_test/domain/entities/article.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app_test/data/models/article_model.dart';

abstract class LocalDataSource {
  Future<List<Article>> load();
  Future<void> saveArticles({required List<Article> articles});
}

class LocalDataSourceImpl implements LocalDataSource {
  static const storageKey = 'articles';
  final SharedPreferences _sharedPreferences;

  const LocalDataSourceImpl(SharedPreferences sharedPreferences)
      : _sharedPreferences = sharedPreferences;

  @override
  Future<List<Article>> load() async {
    try {
      final storedArticlesData = _sharedPreferences.getStringList(storageKey);
      if (storedArticlesData == null || storedArticlesData.isEmpty) {
        return [];
      }
      return storedArticlesData.map((article) =>
          // ignore: unnecessary_cast
          ArticleModel.fromJson(json.decode(article)) as Article).toList();
    } catch (error) {
      throw LocalDataSourceException(errorMessage: error.toString());
    }
  }

  @override
  Future<void> saveArticles({required List<Article> articles}) async {
    final List<String> jsonArticles = articles
        .cast<ArticleModel>()
        .map((article) => json.encode(article.toJson()))
        .toList();
    await _sharedPreferences.setStringList(storageKey, jsonArticles);
  }
}
