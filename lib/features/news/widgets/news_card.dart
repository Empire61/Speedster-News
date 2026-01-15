import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../news/models/article.dart';
import '../../../core/utils/date_formatter.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ArticleImage(imageUrl: article.urlToImage),
              const SizedBox(height: 12),
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              _ArticleMeta(article: article),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleImage extends StatelessWidget {
  final String? imageUrl;

  const _ArticleImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => _placeholder(),
        errorWidget: (context, url, error) => _placeholder(),
        memCacheHeight: 360,
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 180,
      color: Colors.grey[300],
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 48,
        color: Colors.grey[500],
      ),
    );
  }
}


class _ArticleMeta extends StatelessWidget {
  final Article article;

  const _ArticleMeta({required this.article});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.source_outlined,
          size: 14,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            article.source.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.access_time, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          DateFormatter.formatTimeAgo(article.publishedAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}