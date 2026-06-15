import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/theme/app_colors.dart';

abstract final class AppTheme {
  static const CupertinoThemeData light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    applyThemeToAll: true,
    scaffoldBackgroundColor: AppColors.background,
    barBackgroundColor: AppColors.background,
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(
        fontFamily: '.SF Pro Text',
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
      navTitleTextStyle: TextStyle(
        fontFamily: '.SF Pro Display',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      navLargeTitleTextStyle: TextStyle(
        fontFamily: '.SF Pro Display',
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      ),
    ),
  );
}
