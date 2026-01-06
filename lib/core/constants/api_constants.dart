class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://newsapi.org/v2';

  // Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 10);

  // SharedPreferences keys (for API rate limiting)
  static const String requestCountKey = 'api_request_count';
  static const String lastResetDateKey = 'api_last_reset_date';

    // Rate limit
  static const int maxRequestsPerDay = 100;

}