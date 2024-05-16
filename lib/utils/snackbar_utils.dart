import "package:flutter/material.dart";
import "package:qasheets/utils/app_styles.dart";

class SnackBarUtils {
  static DateTime? _lastSnackbarTime;
  static const int debounceDurationMs = 2000; 

  static void showSnackbar(BuildContext context, IconData icon, String message) {

    final DateTime now = DateTime.now();

    if (_lastSnackbarTime == null ||
        now.difference(_lastSnackbarTime!).inMilliseconds > debounceDurationMs) {
      _lastSnackbarTime = now;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                icon,
                color: AppTheme.accent,
              ),
              const SizedBox(width: 10),
              Text(message),
            ],
          ),
        ),
      );
    }
  }
}
