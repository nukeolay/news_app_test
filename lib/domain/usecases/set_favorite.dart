import 'package:news_app_test/domain/entities/article.dart';
import 'package:news_app_test/domain/repositories/favorite_repoitory.dart';

class SetFavorite {
  final FavoriteRepository _favoriteRepository;

  const SetFavorite(FavoriteRepository favoriteRepository)
      : _favoriteRepository = favoriteRepository;

  Future<void> call({required Article article}) async {
    await _favoriteRepository.setFavoriteArticle(article);
  }
}
