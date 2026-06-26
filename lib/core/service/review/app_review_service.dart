import 'dart:async';

import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppReviewService {
  AppReviewService._();

  static final AppReviewService instance = AppReviewService._();

  static const _generationCountKey = 'successful_generation_count';

  bool _pendingReview = false;

  Future<void> onGenerationSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_generationCountKey) ?? 0) + 1;
    await prefs.setInt(_generationCountKey, count);

    if (count == 1 || count == 3 || count == 7) {
      _pendingReview = true;
    }
  }

  Future<void> requestReviewIfPending() async {
    if (!_pendingReview) {
      return;
    }

    _pendingReview = false;

    final review = InAppReview.instance;
    if (!await review.isAvailable()) {
      return;
    }

    await review.requestReview();
  }
}
