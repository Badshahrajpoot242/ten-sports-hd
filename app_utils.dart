// lib/core/utils/app_utils.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../theme/app_theme.dart';

class AppUtils {
  AppUtils._();

  static void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? AppTheme.primaryRed : AppTheme.surfaceBg,
      textColor: AppTheme.textPrimary,
      fontSize: 14.0,
    );
  }

  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.primaryRed : AppTheme.surfaceBg,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static bool isYoutubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  static bool isM3u8Url(String url) {
    return url.toLowerCase().contains('.m3u8');
  }

  static String getVideoType(String url) {
    if (isYoutubeUrl(url)) return 'youtube';
    if (isM3u8Url(url)) return 'm3u8';
    return 'mp4';
  }

  static String extractYoutubeId(String url) {
    RegExp regExp = RegExp(
      r'^.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#&?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(url);
    return match?.group(1) ?? '';
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
