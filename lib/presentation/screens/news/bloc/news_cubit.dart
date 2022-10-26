import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_test/core/errors/exceptions.dart';
import 'package:news_app_test/domain/entities/article.dart';
import 'package:news_app_test/domain/usecases/get_articles.dart';
import 'package:news_app_test/domain/usecases/set_favorite.dart';
import 'package:news_app_test/presentation/screens/news/bloc/news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetArticles _getArticles;
  final SetFavorite _setFavorite;
  final NewsType _newsType;

  NewsCubit({
    required GetArticles getArticles,
    required SetFavorite setFavorite,
    required NewsType newsType,
  })  : _getArticles = getArticles,
        _setFavorite = setFavorite,
        _newsType = newsType,
        super(NewsEmpty());

  int page = 1;

  Future<void> refresh() async {
    if (state is NewsLoading) return;
    final currentState = state;
    List<Article> oldArticles = [];
    if (currentState is NewsLoaded) {
      oldArticles = currentState.articles;
    }
    if (currentState is NewsError) {
      oldArticles = currentState.oldArticles;
    }
    emit(NewsLoading(oldArticles, isInit: false));
    try {
      final articles = (state as NewsLoading).oldArticles;
      final latestArticles = await _getArticles(page: 1, newsType: _newsType);
      final List<Article> newArticles = [];
      for (var article in latestArticles) {
        if (!articles.contains(article)) {
          newArticles.add(article);
        }
      }
      if (newArticles.isNotEmpty) {
        articles.insertAll(0, newArticles);
      }
      emit(NewsLoaded(articles));
    } catch (error) {
      log(error.toString());
      emit(NewsError(message: _errorHandler(error), oldArticles: oldArticles));
    }
  }

  Future<void> setFavorite(Article article) async {
    await _setFavorite(article: article);
  }

  Future<void> loadNews() async {
    if (state is NewsLoading) return;
    final currentState = state;
    List<Article> oldArticles = [];
    if (currentState is NewsLoaded) {
      oldArticles = currentState.articles;
    }
    if (currentState is NewsError) {
      oldArticles = currentState.oldArticles;
    }
    emit(NewsLoading(oldArticles, isInit: page == 1));
    try {
      final newArticles = await _getArticles(page: page, newsType: _newsType);
      page++;
      final articles = (state as NewsLoading).oldArticles;
      articles.addAll(newArticles);
      emit(NewsLoaded(articles));
    } catch (error) {
      emit(NewsError(message: _errorHandler(error), oldArticles: oldArticles));
    }
  }

  String _errorHandler(Object error) {
    switch (error.runtimeType) {
      case RemoteDataSourceException:
        return 'Error fetching news from server';
      case NetworkConnectionException:
        return 'Network connection error';
      case LocalDataSourceException:
        return 'Error reading / writing local storage';
      default:
        return 'Unknown Error';
    }
  }
}
