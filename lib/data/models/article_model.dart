import 'package:news_app_test/data/models/article_source_model.dart';
import 'package:news_app_test/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required source,
    required author,
    required title,
    required description,
    required url,
    required urlToImage,
    required publishedAt,
    required content,
    required isFavorite,
  }) : super(
          source: source,
          author: author,
          title: title,
          description: description,
          url: url,
          urlToImage: urlToImage,
          publishedAt: publishedAt,
          content: content,
          isFavorite: isFavorite,
        );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source: ArticleSourceModel.fromJson(json[ArticleFields.source]),
      author: json[ArticleFields.author] == null
          ? ''
          : json[ArticleFields.author] as String,
      title: json[ArticleFields.title] == null
          ? ''
          : json[ArticleFields.title] as String,
      description: json[ArticleFields.description] == null
          ? ''
          : json[ArticleFields.description] as String,
      url: json[ArticleFields.url] == null
          ? ''
          : json[ArticleFields.url] as String,
      urlToImage: json[ArticleFields.urlToImage] == null
          ? ''
          : json[ArticleFields.urlToImage] as String,
      publishedAt: DateTime.parse(json[ArticleFields.publishedAt] as String),
      content: json[ArticleFields.content] == null
          ? ''
          : json[ArticleFields.content] as String,
      isFavorite: json[ArticleFields.isFavorite] == null
          ? false
          : json[ArticleFields.isFavorite] == true
              ? true
              : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ArticleFields.source: source,
      ArticleFields.author: author,
      ArticleFields.title: title,
      ArticleFields.description: description,
      ArticleFields.url: url,
      ArticleFields.urlToImage: urlToImage,
      ArticleFields.publishedAt: publishedAt.toIso8601String(),
      ArticleFields.content: content,
      ArticleFields.isFavorite: isFavorite,
    };
  }
}

class ArticleFields {
  static const source = 'source';
  static const author = 'author';
  static const title = 'title';
  static const description = 'description';
  static const url = 'url';
  static const urlToImage = 'urlToImage';
  static const publishedAt = 'publishedAt';
  static const content = 'content';
  static const isFavorite = 'isFavorite';
}
