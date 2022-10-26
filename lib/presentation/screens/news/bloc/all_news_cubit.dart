import 'package:news_app_test/domain/usecases/get_articles.dart';
import 'package:news_app_test/presentation/screens/news/bloc/news_cubit.dart';

class AllNewsCubit extends NewsCubit {
  AllNewsCubit({
    required super.getArticles,
    required super.setFavorite,
    required super.getFavorites,
  }) : super(newsType: NewsType.all);
}
