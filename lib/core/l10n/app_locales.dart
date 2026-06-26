import 'package:flutter/cupertino.dart';

abstract final class AppLocales {
  static const Locale fallback = Locale('en');

  static const List<Locale> supported = [
    Locale('en'),
    Locale('ru'),
    Locale('es'),
    Locale('de'),
    Locale('fr'),
    Locale('pt'),
    Locale('it'),
    Locale('tr'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];
}
