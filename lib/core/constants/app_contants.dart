class AppConstants {
  // Cache / Preference keys (UI or app-level)
  static const String selectedCountryKey = 'selected_country';
  static const String selectedCategoryKey = 'selected_category';
  static const String themeModeKey = 'theme_mode';

  // Default values
  static const String defaultCountry = 'us';
  static const String defaultCategory = 'general';

  // News categories
  static const List<String> newsCategories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  // Category display names
  static const Map<String, String> categoryDisplayNames = {
    'general': 'All',
    'business': 'Business',
    'entertainment': 'Entertainment',
    'health': 'Health',
    'science': 'Science',
    'sports': 'Sports',
    'technology': 'Technology',
  };

  // Supported countries
  static const Map<String, String> supportedCountries = {
    'ae': 'United Arab Emirates',
    'ar': 'Argentina',
    'at': 'Austria',
    'au': 'Australia',
    'be': 'Belgium',
    'bg': 'Bulgaria',
    'br': 'Brazil',
    'ca': 'Canada',
    'ch': 'Switzerland',
    'cn': 'China',
    'co': 'Colombia',
    'cu': 'Cuba',
    'cz': 'Czech Republic',
    'de': 'Germany',
    'eg': 'Egypt',
    'fr': 'France',
    'gb': 'United Kingdom',
    'gr': 'Greece',
    'hk': 'Hong Kong',
    'hu': 'Hungary',
    'id': 'Indonesia',
    'ie': 'Ireland',
    'il': 'Israel',
    'in': 'India',
    'it': 'Italy',
    'jp': 'Japan',
    'kr': 'South Korea',
    'lt': 'Lithuania',
    'lv': 'Latvia',
    'ma': 'Morocco',
    'mx': 'Mexico',
    'my': 'Malaysia',
    'ng': 'Nigeria',
    'nl': 'Netherlands',
    'no': 'Norway',
    'nz': 'New Zealand',
    'ph': 'Philippines',
    'pl': 'Poland',
    'pt': 'Portugal',
    'ro': 'Romania',
    'rs': 'Serbia',
    'ru': 'Russia',
    'sa': 'Saudi Arabia',
    'se': 'Sweden',
    'sg': 'Singapore',
    'si': 'Slovenia',
    'sk': 'Slovakia',
    'th': 'Thailand',
    'tr': 'Turkey',
    'tw': 'Taiwan',
    'ua': 'Ukraine',
    'us': 'United States',
    've': 'Venezuela',
    'za': 'South Africa',
  };

  // Error messages
  static const String networkErrorMessage =
      'No internet connection. Please check your network settings.';
  static const String timeoutErrorMessage =
      'Connection timeout. Please try again.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String rateLimitErrorMessage =
      'Daily request limit reached. Try again tomorrow.';
  static const String unknownErrorMessage =
      'Something went wrong. Please try again.';

  // UI constants
  static const double defaultPadding = 16.0;
  static const double cardElevation = 2.0;
  static const double borderRadius = 12.0;

  // Search debounce
  static const Duration searchDebounceDuration = Duration(milliseconds: 500);
}