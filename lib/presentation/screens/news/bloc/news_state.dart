import 'package:equatable/equatable.dart';
import 'package:news_app_test/domain/entities/article.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsEmpty extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsLoading extends NewsState {
  final List<Article> oldArticles;
  final bool isInit;

  const NewsLoading(this.oldArticles, {this.isInit = false});

  @override
  List<Object> get props => [oldArticles];
}

class NewsLoaded extends NewsState {
  final List<Article> articles;

  const NewsLoaded(this.articles);

  @override
  List<Object> get props => [articles];
}

class NewsError extends NewsState {
  final List<Article> oldArticles;
  final String message;

  const NewsError({required this.message, required this.oldArticles});

  @override
  List<Object> get props => [message];
}
