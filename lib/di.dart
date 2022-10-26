import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_test/domain/usecases/get_favorites.dart';
import 'package:news_app_test/presentation/screens/favorites/bloc/favorites_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_app_test/data/datasources/local_datasource.dart';
import 'package:news_app_test/data/repositories/favorite_reposotory_impl.dart';
import 'package:news_app_test/domain/repositories/favorite_repoitory.dart';
import 'package:news_app_test/domain/usecases/get_articles.dart';
import 'package:news_app_test/domain/usecases/set_favorite.dart';
import 'package:news_app_test/presentation/screens/news/bloc/all_news_cubit.dart';
import 'package:news_app_test/presentation/screens/news/bloc/top_news_cubit.dart';
import 'package:news_app_test/data/datasources/remote_datasource.dart';
import 'package:news_app_test/data/platform/connection_cheker.dart';
import 'package:news_app_test/data/repositories/articles_reposotory_impl.dart';
import 'package:news_app_test/domain/repositories/articles_repoitory.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // ! blocs
  serviceLocator.registerFactory<AllNewsCubit>(
    () => AllNewsCubit(
      getArticles: serviceLocator<GetArticles>(),
      setFavorite: serviceLocator<SetFavorite>(),
      getFavorites: serviceLocator<GetFavorites>(),
    ),
  );

  serviceLocator.registerFactory<TopNewsCubit>(
    () => TopNewsCubit(
      getArticles: serviceLocator<GetArticles>(),
      setFavorite: serviceLocator<SetFavorite>(),
      getFavorites: serviceLocator<GetFavorites>(),
    ),
  );

  serviceLocator.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(
      setFavorite: serviceLocator<SetFavorite>(),
      getFavorites: serviceLocator<GetFavorites>(),
    ),
  );

  // ! use cases
  serviceLocator.registerLazySingleton(() => GetArticles(
        articlesRepository: serviceLocator<ArticlesRepository>(),
        favoriteRepository: serviceLocator<FavoriteRepository>(),
      ));

  serviceLocator.registerLazySingleton(
      () => SetFavorite(serviceLocator<FavoriteRepository>()));

  serviceLocator.registerLazySingleton(() => GetFavorites(
        favoriteRepository: serviceLocator<FavoriteRepository>(),
      ));

  // ! repositories
  serviceLocator.registerLazySingleton<ArticlesRepository>(
    () => ArticlesRepositoryImpl(
      connectionCheker: serviceLocator<ConnectionCheker>(),
      remoteDataSource: serviceLocator<RemoteDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(
      localDataSource: serviceLocator<LocalDataSource>(),
    ),
  );

  // ! data sources
  serviceLocator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(serviceLocator<http.Client>()),
  );

  serviceLocator.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(serviceLocator<SharedPreferences>()),
  );

  // ! externals
  final sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator
      .registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());

  serviceLocator.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());

  serviceLocator.registerLazySingleton<ConnectionCheker>(
    () => ConnectionChekerImpl(serviceLocator<InternetConnectionChecker>()),
  );
}
