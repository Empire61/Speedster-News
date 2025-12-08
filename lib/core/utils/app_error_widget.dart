import'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget{
  final FlutterErrorDetails errorDetails;

  const AppErrorWidget({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error_outline, size: 80, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Something went wrong!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Please restart the app.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}