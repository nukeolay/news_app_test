import 'package:news_app_test/domain/usecases/get_articles.dart';
import 'package:news_app_test/presentation/screens/news/bloc/news_cubit.dart';

class TopNewsCubit extends NewsCubit {
  TopNewsCubit({
    required super.getArticles,
    required super.setFavorite,
  }) : super(newsType: NewsType.top);
}
