export 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension AppAnimations on Widget {
  Widget animateFadeUp({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
    double slideBegin = 0.06,
    Curve curve = Curves.easeOutCubic,
  }) {
    return animate()
        .fadeIn(duration: duration, delay: delay, curve: curve)
        .slideY(
          begin: slideBegin,
          end: 0,
          duration: duration,
          delay: delay,
          curve: curve,
        );
  }

  Widget animateFadeScale({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 480),
    double scaleBegin = 0.94,
    Curve curve = Curves.easeOutCubic,
  }) {
    return animate()
        .fadeIn(duration: duration, delay: delay, curve: curve)
        .scale(
          begin: Offset(scaleBegin, scaleBegin),
          end: const Offset(1, 1),
          duration: duration,
          delay: delay,
          curve: curve,
        );
  }

  Widget animateStagger(
    int index, {
    int stepMs = 70,
    Duration duration = const Duration(milliseconds: 480),
  }) {
    return animateFadeUp(
      delay: Duration(milliseconds: stepMs * index),
      duration: duration,
    );
  }

  Widget animateSlideEntrance({
    required bool isActive,
    required Object keyValue,
    Duration duration = const Duration(milliseconds: 450),
  }) {
    if (!isActive) {
      return this;
    }

    return animate(key: ValueKey(keyValue))
        .fadeIn(duration: duration, curve: Curves.easeOutCubic)
        .slideY(
          begin: 0.05,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }

  Widget animatePulse({Duration duration = const Duration(milliseconds: 1400)}) {
    return animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(0.97, 0.97),
          end: const Offset(1, 1),
          duration: duration,
          curve: Curves.easeInOut,
        );
  }

  Widget animateShimmer({Duration duration = const Duration(milliseconds: 1800)}) {
    return animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: duration,
          color: const Color(0x22FFFFFF),
        );
  }
}
