import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/constants/app_constants.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image (if available)
            if (article.urlToImage != null)
              CachedNetworkImage(
                imageUrl: article.urlToImage!,
                width: double.infinity,
                height: AppConstants.detailScreenImageHeight,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: AppConstants.detailScreenImageHeight,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: AppConstants.detailScreenImageHeight,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: AppConstants.iconSizeExtraLarge,
                    color: Colors.grey[500],
                  ),
                ),
                memCacheHeight: AppConstants.detailScreenImageMemCacheHeight.toInt(),
              ),

            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),

                  // Metadata Row
                  Row(
                    children: [
                      Icon(
                        Icons.source_outlined,
                        size: AppConstants.iconSizeMedium,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        article.source.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Text(
                        '•',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Text(
                        DateFormatter.formatFullDate(article.publishedAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingExtraLarge),

                  // Description
                  if (article.description != null && article.description!.isNotEmpty)
                    Text(
                      article.description!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            color: Colors.grey[800],
                          ),
                    )
                  else
                    Text(
                      'No description available for this article.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}