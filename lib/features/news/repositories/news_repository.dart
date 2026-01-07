import '../models/article.dart';
import '../services/news_api_service.dart';
import '../services/cache_service.dart';
import 'dart:developer' as developer;

class NewsRepository {
  final NewsApiService _api;
  final CacheService _cache;

  NewsRepository(this._api, this._cache);

  Future<List<Article>> getTopHeadlines({
    required String country,
    String? category,
  }) async {
    final cacheKey = 'top_${country}_${category ?? "general"}';

    final cached = await _cache.getFromCache(cacheKey);
    if (cached != null) {
      developer.log('Cache hit for $cacheKey', name: 'NewsRepository');
      return cached.map(Article.fromJson).toList();
    }

    final response = await _api.fetchTopHeadlines(
      country: country,
      category: category,
    );

    final List<dynamic> articlesJsonList = response['articles'] ?? [];
    final articlesJson = articlesJsonList.cast<Map<String, dynamic>>();

    await _cache.saveToCache(cacheKey, articlesJson);

    return articlesJson.map(Article.fromJson).toList();
  }
}
