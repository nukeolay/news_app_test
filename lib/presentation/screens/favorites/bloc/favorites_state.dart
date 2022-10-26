import 'package:equatable/equatable.dart';
import 'package:news_app_test/domain/entities/article.dart';

abstract class FavoritesState extends Equatable {
  final List<Article> articles;
  const FavoritesState(this.articles);

  @override
  List<Object> get props => [articles];
}

class FavoritesEmpty extends FavoritesState {
  const FavoritesEmpty(super.articles);

  @override
  List<Object> get props => [articles];
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading(super.articles);

  @override
  List<Object> get props => [articles];
}

class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded(super.articles);

  @override
  List<Object> get props => [articles];
}

class FavoritesError extends FavoritesState {
  final String errorMessage;

  const FavoritesError({
    required List<Article> articles,
    required this.errorMessage,
  }) : super(articles);

  @override
  List<Object> get props => [errorMessage, articles];
}
