import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const int maxRequestsPerDay = 100;
  static const String _requestCountKey = 'api_request_count';
  static const String _lastResetDateKey = 'api_last_reset_date';
  
  final Dio _dio;

  int _requestCount = 0;
  DateTime? _lastResetDate;

  // Private constructor
  NewsApiService._internal(String apiKey)
      : _dio = Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'X-Api-Key': apiKey,
            },
          ),
        );

  // Factory constructor to properly handle async initialization
  static Future<NewsApiService> create(String apiKey) async {
    final service = NewsApiService._internal(apiKey);
    await service._loadRateLimitData();
    return service;
  }

  // Load rate limit data from SharedPreferences
  Future<void> _loadRateLimitData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _requestCount = prefs.getInt(_requestCountKey) ?? 0;

      final dateString = prefs.getString(_lastResetDateKey);
      if (dateString != null) {
        _lastResetDate = DateTime.parse(dateString);
      }

      await _checkAndResetIfNeeded();
    } catch (e) {
      developer.log('Error loading rate limit data: $e', name: 'NewsApiService');
    }
  }

  Future<void> _checkAndResetIfNeeded() async {
    final now = DateTime.now();

    if (_lastResetDate == null || !_isSameDay(_lastResetDate!, now)) {
      _requestCount = 0;
      _lastResetDate = now;
      await _saveRateLimitData();
    }
  }

  Future<void> _saveRateLimitData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_requestCountKey, _requestCount);
      await prefs.setString(_lastResetDateKey, _lastResetDate!.toIso8601String());
    } catch (e) {
      developer.log('Rate limit data loaded', name: 'NewsApiService');
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) =>
      d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

  Future<void> _checkRateLimit() async {
    await _checkAndResetIfNeeded();

    if (_requestCount >= maxRequestsPerDay) {
      throw RateLimitException(
        'Daily rate limit exceeded. You have made $_requestCount requests today. Limit resets at midnight.',
      );
    }

    _requestCount++;
    await _saveRateLimitData();
  }

  Future<int> getRemainingRequests() async {
    await _checkAndResetIfNeeded();
    return maxRequestsPerDay - _requestCount;
  }

  // Fetch top headlines
  Future<Map<String, dynamic>> fetchTopHeadlines({
    required String country,
    String? category,
  }) async {
    try {
      await _checkRateLimit();

      final response = await _dio.get(
        '/top-headlines',
        queryParameters: {
          'country': country,
          if (category != null && category != 'general') 'category': category,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ApiException('Failed to fetch news: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Search news articles
  Future<Map<String, dynamic>> searchNews(String query) async {
    try {
      await _checkRateLimit();

      final response = await _dio.get(
        '/everything',
        queryParameters: {
          'q': query,
          'sortBy': 'publishedAt',
          'language': 'en',
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ApiException('Failed to search news: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');

      case DioExceptionType.connectionError:
        return NetworkException('No internet connection. Please check your network settings.');

      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status == 401) return ApiException('Invalid API key.');
        if (status == 429) return RateLimitException('Too many requests.');
        if (status == 500) return ServerException('Server error.');
        return ApiException('Request failed with status code: $status');

      default:
        return ApiException('Unexpected error: ${error.message}');
    }
  }
}

// Custom exceptions
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
  @override
  String toString() => message;
}

class RateLimitException implements Exception {
  final String message;
  RateLimitException(this.message);
  @override
  String toString() => message;
}