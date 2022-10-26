import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_test/core/errors/exceptions.dart';
import 'package:news_app_test/domain/entities/article.dart';
import 'package:news_app_test/domain/usecases/get_favorites.dart';
import 'package:news_app_test/domain/usecases/set_favorite.dart';
import 'package:news_app_test/presentation/screens/favorites/bloc/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final SetFavorite _setFavorite;
  final GetFavorites _getFavorites;

  FavoritesCubit({
    required SetFavorite setFavorite,
    required GetFavorites getFavorites,
  })  : _setFavorite = setFavorite,
        _getFavorites = getFavorites,
        super(const FavoritesEmpty([]));

  Future<void> removeFromFavorites(Article article) async {
    final currentState = state;
    emit(FavoritesLoading(currentState.articles));
    await _setFavorite(article: article);
    final articles = currentState.articles;
    articles.removeWhere((element) => element.url == article.url);
    emit(FavoritesLoaded(articles));
  }

  Future<void> loadFavorites() async {
    if (state is FavoritesLoading) return;
    final currentState = state;
    List<Article> oldArticles = [];
    if (currentState is FavoritesLoaded) {
      oldArticles = currentState.articles;
    }
    if (currentState is FavoritesError) {
      oldArticles = currentState.articles;
    }
    emit(FavoritesLoading(oldArticles));
    try {
      final favoriteArticles = await _getFavorites();
      emit(FavoritesLoaded(favoriteArticles));
    } catch (error) {
      emit(FavoritesError(
        errorMessage: _errorHandler(error),
        articles: oldArticles,
      ));
    }
  }

  String _errorHandler(Object error) {
    switch (error.runtimeType) {
      case LocalDataSourceException:
        return 'Error reading / writing local storage';
      default:
        return 'Unknown Error';
    }
  }
}
