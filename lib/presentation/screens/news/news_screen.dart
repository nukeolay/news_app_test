import 'package:flutter/material.dart';
import 'package:news_app_test/presentation/common/widgets/news_list.dart';
import 'package:news_app_test/presentation/screens/news/bloc/all_news_cubit.dart';
import 'package:news_app_test/presentation/screens/news/bloc/top_news_cubit.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  var _selectedTabIndex = 0;

  late final TabController _controller;

  final _titles = const ['Top headlines', 'Everything'];

  final _tabs = const [
    Tab(child: Icon(Icons.list_alt)),
    Tab(child: Icon(Icons.list)),
  ];

  final _screens = const [
    NewsList<TopNewsCubit>(isPullable: false),
    NewsList<AllNewsCubit>(isPullable: true),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedTabIndex = _controller.index;
    });
  }

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      _onTabChange(_controller.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedTabIndex]),
          bottom: TabBar(
            controller: _controller,
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: _screens,
        ),
      ),
    );
  }
}
