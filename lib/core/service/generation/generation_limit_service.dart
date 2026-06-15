import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:home_ai/core/logger/app_logger.dart';
import 'package:home_ai/core/service/premium/premium_service.dart';

/// Tracks free generation usage in secure storage.
///
/// Free users get [freeLimit] generations. Once consumed, the paywall
/// must be shown. Premium users are never limited.
class GenerationLimitService {
  GenerationLimitService._();

  static final GenerationLimitService instance = GenerationLimitService._();

  static const int freeLimit = 1;
  static const _usedCountKey = 'free_generations_used';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<int> usedCount() async {
    try {
      final raw = await _storage.read(key: _usedCountKey);
      return int.tryParse(raw ?? '') ?? 0;
    } catch (error) {
      AppLogger.instance.warning('GenerationLimit: read failed — $error');
      return 0;
    }
  }

  Future<int> remainingFree() async {
    final used = await usedCount();
    final remaining = freeLimit - used;
    return remaining > 0 ? remaining : 0;
  }

  /// Whether the user is allowed to start a generation right now.
  Future<bool> canGenerate() async {
    if (PremiumService.instance.havePremium.value) {
      return true;
    }
    return await remainingFree() > 0;
  }

  /// Records one used free generation. No-op for premium users.
  Future<void> consumeFreeGeneration() async {
    if (PremiumService.instance.havePremium.value) {
      return;
    }

    try {
      final used = await usedCount();
      await _storage.write(
        key: _usedCountKey,
        value: (used + 1).toString(),
      );
    } catch (error) {
      AppLogger.instance.warning('GenerationLimit: write failed — $error');
    }
  }

  Future<void> reset() async {
    try {
      await _storage.delete(key: _usedCountKey);
    } catch (error) {
      AppLogger.instance.warning('GenerationLimit: reset failed — $error');
    }
  }
}
