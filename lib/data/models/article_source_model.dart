import 'package:news_app_test/domain/entities/article_source.dart';

class ArticleSourceModel extends ArticleSource {
  const ArticleSourceModel({
    required String id,
    required String name,
  }) : super(
          id: id,
          name: name,
        );

  factory ArticleSourceModel.fromJson(Map<String, dynamic> json) {
    return ArticleSourceModel(
      id: json[ArticleSourceFields.id] == null
          ? ''
          : json[ArticleSourceFields.id] as String,
      name: json[ArticleSourceFields.name] == null
          ? ''
          : json[ArticleSourceFields.name] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class ArticleSourceFields {
  static const id = 'id';
  static const name = 'name';
}
