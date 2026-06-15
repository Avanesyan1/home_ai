import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ResponsiveFontSize on num {
  /// Scales with ScreenUtil and clamps to `[base, base + 4]`.
  double get spClamped {
    final base = toDouble();
    return sp.clamp(base, base + 4);
  }
}
