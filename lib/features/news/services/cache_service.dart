import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _cachePrefix = 'news_cache_';
  static const String _timestampSuffix = '_timestamp';
  static const Duration cacheDuration = Duration(minutes: 15);

  Future<void> saveToCache(String key, List<Map<String, dynamic>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _cachePrefix + key;
      final timestampKey = cacheKey + _timestampSuffix;
      
      await prefs.setString(cacheKey, jsonEncode(data));
      await prefs.setString(timestampKey, DateTime.now().toIso8601String());
      
      developer.log('Cached data for key: $key', name: 'CacheService');
    } catch (e) {
      developer.log('Cache save failed: $e', name: 'CacheService');
    }
  }

  Future<List<Map<String, dynamic>>?> getFromCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _cachePrefix + key;
      final timestampKey = cacheKey + _timestampSuffix;
      
      final cachedData = prefs.getString(cacheKey);
      final timestampString = prefs.getString(timestampKey);
      
      if (cachedData == null || timestampString == null) return null;
      
      final timestamp = DateTime.parse(timestampString);
      if (DateTime.now().difference(timestamp) > cacheDuration) {
        await clearCache(key);
        return null;
      } 

      final List<dynamic> decoded = jsonDecode(cachedData);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      developer.log('Cache read failed: $e', name: 'CacheService');
      return null;
    }
  }

  Future<void> clearCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachePrefix + key);
    await prefs.remove(_cachePrefix + key + _timestampSuffix);
  }
}
