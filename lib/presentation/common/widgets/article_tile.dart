import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app_test/domain/entities/article.dart';
import 'package:news_app_test/presentation/screens/article_detail/article_detail_screen.dart';

class ArticleTile extends StatefulWidget {
  final Article article;
  final VoidCallback onSetFavorite;

  const ArticleTile({
    Key? key,
    required this.article,
    required this.onSetFavorite,
  }) : super(key: key);

  @override
  State<ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  void _onTileTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: widget.article),
      ),
    );
  }

  Widget _image(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        color: Theme.of(context).errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width * 0.2;
    final article = widget.article;
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      leading: SizedBox(
        width: imageWidth,
        height: imageWidth,
        child: _image(article.urlToImage),
      ),
      title: Text(article.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(article.description),
          Text(
            DateFormat('HH:mm dd.MM.yyyy').format(article.publishedAt),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: widget.onSetFavorite,
        icon: article.isFavorite
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border),
      ),
      onTap: () => _onTileTap(context),
    );
  }
}
