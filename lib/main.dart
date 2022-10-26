import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_test/di.dart';
import 'package:news_app_test/presentation/screens/favorites/bloc/favorites_cubit.dart';
import 'package:news_app_test/presentation/screens/main/main_screen.dart';
import 'package:news_app_test/presentation/screens/news/bloc/all_news_cubit.dart';
import 'package:news_app_test/presentation/screens/news/bloc/top_news_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AllNewsCubit>(
          create: (context) => serviceLocator<AllNewsCubit>()..loadNews(),
        ),
        BlocProvider<TopNewsCubit>(
          create: (context) => serviceLocator<TopNewsCubit>()..loadNews(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) => serviceLocator<FavoritesCubit>()..loadFavorites(),
        ),
      ],
      child: const NewsApp(),
    ),
  );
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = ColorScheme.fromSeed(
    //     seedColor: Colors.indigo, brightness: Brightness.dark);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      // theme: ThemeData(
      //   useMaterial3: true,
      //   colorScheme: colorScheme,
      //   brightness: Brightness.dark,
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ButtonStyle(
      //       backgroundColor: MaterialStateProperty.all(colorScheme.primary),
      //       foregroundColor: MaterialStateProperty.all(colorScheme.onSecondary),
      //     ),
      //   ),
      // ),
      // onGenerateRoute: Routes.onGenerateRoute,
      home: MainScreen(),
    );
  }
}
