import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../news/models/article.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/constants/app_constants.dart';

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
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingLarge,
        vertical: AppConstants.paddingSmall,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ArticleImage(imageUrl: article.urlToImage),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
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
      borderRadius: BorderRadius.circular(AppConstants.imageBorderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        height: AppConstants.newsCardImageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => _placeholder(),
        errorWidget: (context, url, error) => _placeholder(),
        memCacheHeight: AppConstants.newsCardImageMemCacheHeight.toInt(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: AppConstants.newsCardImageHeight,
      color: Colors.grey[300],
      child: Icon(
        Icons.image_not_supported_outlined,
        size: AppConstants.iconSizeLarge,
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
          size: AppConstants.iconSizeSmall,
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
        const SizedBox(width: AppConstants.paddingMedium),
        const Icon(
          Icons.access_time,
          size: AppConstants.iconSizeSmall,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          DateFormatter.formatTimeAgo(article.publishedAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}