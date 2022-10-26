class ApiConstants {
  static const _apiKey = '1bc6526622e34e1fb2417ddfb58c87fc';
  static const _baseUrl = 'https://newsapi.org';
  static const _topic = 'Apple';
  static const _topNews = '/v2/top-headlines';
  static const _allNews = '/v2/everything';
  static const _pageSize = 15;
  static const topNewsUrl =
      '$_baseUrl$_topNews?q=$_topic&pageSize=$_pageSize&apiKey=$_apiKey';
  static const allNewsUrl =
      '$_baseUrl$_allNews?q=$_topic&pageSize=$_pageSize&apiKey=$_apiKey';
}
