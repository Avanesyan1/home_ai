import 'package:flutter/cupertino.dart';

abstract final class AppLocales {
  static const Locale fallback = Locale('en');

  static const List<Locale> supported = [
    Locale('en'),
    Locale('ru'),
  ];
}
