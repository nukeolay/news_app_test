import 'package:equatable/equatable.dart';
import 'package:news_app_test/domain/entities/article.dart';

abstract class NewsState extends Equatable {
  final List<Article> articles;
  const NewsState(this.articles);

  @override
  List<Object> get props => [articles];
}

class NewsEmpty extends NewsState {
  const NewsEmpty(super.articles);

  @override
  List<Object> get props => [articles];
}

class NewsLoading extends NewsState {
  final bool isInit;

  const NewsLoading({
    required List<Article> articles,
    this.isInit = false,
  }) : super(articles);

  @override
  List<Object> get props => [articles];
}

class NewsLoaded extends NewsState {
  const NewsLoaded(super.articles);

  @override
  List<Object> get props => [articles];
}

class NewsError extends NewsState {
  final String errorMessage;

  const NewsError({
    required List<Article> articles,
    required this.errorMessage,
  }) : super(articles);

  @override
  List<Object> get props => [errorMessage, articles];
}
