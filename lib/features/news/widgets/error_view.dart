import 'package:flutter/material.dart';
import '../services/news_api_service.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final errorInfo = _getErrorInfo(error);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              errorInfo.icon,
              size: 80,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 179),
            ),
            const SizedBox(height: 24),
            
            Text(
              errorInfo.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            Text(
              errorInfo.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ErrorInfo _getErrorInfo(Object error) {
    if (error is NetworkException) {
      return _ErrorInfo(
        icon: Icons.wifi_off_rounded,
        title: 'No Internet Connection',
        message: error.toString(),
      );
    } else if (error is RateLimitException) {
      return _ErrorInfo(
        icon: Icons.hourglass_empty_rounded,
        title: 'Rate Limit Reached',
        message: error.toString(),
      );
    } else if (error is ServerException) {
      return _ErrorInfo(
        icon: Icons.cloud_off_rounded,
        title: 'Server Error',
        message: error.toString(),
      );
    } else if (error is ApiException) {
      return _ErrorInfo(
        icon: Icons.error_outline_rounded,
        title: 'API Error',
        message: error.toString(),
      );
    } else {
      return _ErrorInfo(
        icon: Icons.warning_amber_rounded,
        title: 'Something Went Wrong',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }
}

class _ErrorInfo {
  final IconData icon;
  final String title;
  final String message;

  _ErrorInfo({
    required this.icon,
    required this.title,
    required this.message,
  });
}
