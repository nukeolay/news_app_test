import 'package:equatable/equatable.dart';

class ArticleSource extends Equatable {
  final String id;
  final String name;

  const ArticleSource({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
