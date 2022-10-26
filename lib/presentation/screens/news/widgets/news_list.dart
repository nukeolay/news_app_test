import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:news_app_test/domain/entities/article.dart';
import 'package:news_app_test/presentation/common/widgets/article_tile.dart';
import 'package:news_app_test/presentation/screens/news/bloc/top_news_cubit.dart';
import 'package:news_app_test/presentation/screens/news/bloc/all_news_cubit.dart';
import 'package:news_app_test/presentation/screens/news/bloc/news_cubit.dart';
import 'package:news_app_test/presentation/screens/news/bloc/news_state.dart';

class NewsList<T extends NewsCubit> extends StatefulWidget {
  final bool isPullable;
  const NewsList({required this.isPullable, Key? key}) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState<T>();
}

class _NewsListState<T extends NewsCubit> extends State<NewsList> {
  final _scrollController = ScrollController();
  late final bool _isPullable;
  late final Timer _timer;
  bool _isInit = true;

  @override
  void initState() {
    _isPullable = widget.isPullable;
    if (!_isPullable) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        context.read<TopNewsCubit>().refresh();
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      context.read<T>().refresh();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _setupScrollController(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          context.read<T>().loadNews();
        }
      }
    });
  }

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  void _onRefresh() async {
    await context.read<AllNewsCubit>().refresh();
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    if (!_isPullable) {
      _timer.cancel();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setupScrollController(context);

    return BlocBuilder<T, NewsState>(
      builder: (context, state) {
        List<Article> articles = [];
        bool isLoading = false;

        if (state is NewsLoading && state.isInit) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is NewsLoading) {
          articles = state.articles;
          isLoading = true;
        } else if (state is NewsLoaded) {
          articles = state.articles;
        } else if (state is NewsError) {
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).errorColor,
              content: Text(state.errorMessage),
            ));
          });
          articles = state.articles;
        }

        return SmartRefresher(
          enablePullDown: _isPullable,
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < articles.length) {
                return ArticleTile(
                  article: articles[index],
                  onSetFavorite: () =>
                      context.read<T>().setFavorite(articles[index]),
                );
              } else {
                Timer(const Duration(milliseconds: 50), () {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
            itemCount: articles.length + (isLoading ? 1 : 0),
          ),
        );
      },
    );
  }
}
