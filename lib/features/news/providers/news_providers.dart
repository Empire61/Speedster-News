import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:speedster_news/core/constants/app_constants.dart';
import '../models/article.dart';
import '../services/news_api_service.dart';
import '../services/cache_service.dart';
import '../repositories/news_repository.dart';

final newsApiServiceProvider = FutureProvider<NewsApiService>((ref) async{
  final apiKey = dotenv.env['NEWS_API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    throw Exception('Missing NEWS_API_KEY');
  }
  return await NewsApiService.getInstance(apiKey);
});

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
});

// Note: Using FutureProvider here because NewsApiService requires async
// initialization to load rate-limiting data. Alternative approach would be
// lazy initialization on first API call, making this a sync Provider.
// Current approach prioritizes code simplicity.
final newsRepositoryProvider = FutureProvider<NewsRepository>((ref) async {
  final api = await ref.watch(newsApiServiceProvider.future);
  final cache = ref.watch(cacheServiceProvider);
  return NewsRepository(api, cache);
});

final selectedCountryProvider = StateProvider<String>((ref) {
  return AppConstants.defaultCountry;
});
 
final selectedCategoryProvider = StateProvider<String>((ref) {
  return AppConstants.defaultCategory;
});

final newsProvider = FutureProvider.autoDispose<List<Article>>((ref) async {
  final country = ref.watch(selectedCountryProvider);
  final category = ref.watch(selectedCategoryProvider);

  final repository = await ref.watch(newsRepositoryProvider.future);

  return repository.getTopHeadlines(
    country: country,
    category: category,
  );
});

final remainingRequestsProvider = FutureProvider<int>((ref) async {
  final api = await ref.watch(newsApiServiceProvider.future);
  return api.getRemainingRequests();
});
