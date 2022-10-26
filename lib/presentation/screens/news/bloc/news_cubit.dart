import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_test/core/errors/exceptions.dart';
import 'package:news_app_test/domain/entities/article.dart';
import 'package:news_app_test/domain/usecases/get_articles.dart';
import 'package:news_app_test/domain/usecases/get_favorites.dart';
import 'package:news_app_test/domain/usecases/set_favorite.dart';
import 'package:news_app_test/presentation/screens/news/bloc/news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetArticles _getArticles;
  final SetFavorite _setFavorite;
  final GetFavorites _getFavorites;
  final NewsType _newsType;

  NewsCubit({
    required GetArticles getArticles,
    required SetFavorite setFavorite,
    required GetFavorites getFavorites,
    required NewsType newsType,
  })  : _getArticles = getArticles,
        _setFavorite = setFavorite,
        _getFavorites = getFavorites,
        _newsType = newsType,
        super(const NewsEmpty([]));

  int page = 1;

  Future<void> refresh() async {
    if (state is NewsLoading) return;
    final currentState = state;
    List<Article> oldArticles = [];
    if (currentState is NewsLoaded) {
      oldArticles = currentState.articles;
    }
    if (currentState is NewsError) {
      oldArticles = currentState.articles;
    }
    emit(NewsLoading(articles: oldArticles, isInit: false));
    try {
      final articles = (state as NewsLoading).articles;
      final latestArticles = await _getArticles(page: 1, newsType: _newsType);
      final List<Article> newArticles = [];
      for (var article in latestArticles) {
        if (articles.indexWhere((element) => element.url == article.url) ==
            -1) {
          newArticles.add(article);
        }
      }
      if (newArticles.isNotEmpty) {
        articles.insertAll(0, newArticles);
      }
      emit(NewsLoaded(await _updateFavoriteStatus(articles)));
    } catch (error) {
      emit(
          NewsError(errorMessage: _errorHandler(error), articles: oldArticles));
    }
  }

  Future<void> loadNews() async {
    if (state is NewsLoading) return;
    final currentState = state;
    List<Article> oldArticles = [];
    if (currentState is NewsLoaded) {
      oldArticles = currentState.articles;
    }
    if (currentState is NewsError) {
      oldArticles = currentState.articles;
    }
    emit(NewsLoading(articles: oldArticles, isInit: page == 1));
    try {
      final newArticles = await _getArticles(page: page, newsType: _newsType);
      page++;
      final articles = (state as NewsLoading).articles;
      articles.addAll(newArticles);
      emit(NewsLoaded(await _updateFavoriteStatus(articles)));
    } catch (error) {
      emit(
          NewsError(errorMessage: _errorHandler(error), articles: oldArticles));
    }
  }

  Future<List<Article>> _updateFavoriteStatus(List<Article> articles) async {
    final favorites = await _getFavorites();
    for (var article in articles) {
      final favoriteIndex =
          favorites.indexWhere((element) => element.url == article.url);
      if (favoriteIndex != -1) {
        final favoriteArticle = favorites[favoriteIndex];
        final articleToUpdateIndex = articles
            .indexWhere((element) => element.url == favoriteArticle.url);
        articles[articleToUpdateIndex] =
            articles[articleToUpdateIndex].copyWith(isFavorite: true);
      } else {
        final articleToUpdateIndex = articles.indexOf(article);
        articles[articleToUpdateIndex] =
            articles[articleToUpdateIndex].copyWith(isFavorite: false);
      }
    }
    return articles;
  }

  Future<void> setFavorite(Article article) async {
    final currentState = state;
    emit(NewsLoading(articles: currentState.articles));
    final oldArticles = currentState.articles;
    final index =
        oldArticles.indexWhere((element) => element.url == article.url);
    oldArticles[index] = article.copyWith(isFavorite: !article.isFavorite);
    await _setFavorite(article: article);
    emit(NewsLoaded(oldArticles));
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
