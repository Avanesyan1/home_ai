import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';

abstract final class AppAssets {
  static const String cardInteriorBefore = 'assets/images/cards/interior_before.jpg';
  static const String cardInteriorAfter = 'assets/images/cards/interior_after.jpg';
  static const String cardExteriorBefore = 'assets/images/cards/exterior_before.jpg';
  static const String cardExteriorAfter = 'assets/images/cards/exterior_after.jpg';
  static const String cardGardenBefore = 'assets/images/cards/garden_before.jpg';
  static const String cardGardenAfter = 'assets/images/cards/garden_after.jpg';
  static const String cardFloorBefore = 'assets/images/cards/floor_before.png';
  static const String cardFloorAfter = 'assets/images/cards/floor_after.png';

  static const String onboardingBefore = cardFloorBefore;
  static const String onboardingAfter = cardFloorAfter;

  static const List<({String before, String after})> paywallSlides = [
    (before: cardInteriorBefore, after: cardInteriorAfter),
    (before: cardExteriorBefore, after: cardExteriorAfter),
    (before: cardGardenBefore, after: cardGardenAfter),
    (before: cardFloorBefore, after: cardFloorAfter),
  ];

  static const List<String> paywallAfterImages = [
    cardInteriorAfter,
    cardExteriorAfter,
    cardGardenAfter,
    cardFloorAfter,
  ];

  static const List<String> paywallStyleImages = [
    'assets/styles/interior/modern.jpeg',
    'assets/styles/interior/scandinavian.jpeg',
    'assets/styles/exterior/contemporary.jpeg',
    'assets/styles/garden/zen.jpeg',
    'assets/styles/floor/marble.jpeg',
  ];

  static ({String before, String after}) cardPreview(RedesignCategory category) {
    return switch (category) {
      RedesignCategory.interior => (
          before: cardInteriorBefore,
          after: cardInteriorAfter,
        ),
      RedesignCategory.exterior => (
          before: cardExteriorBefore,
          after: cardExteriorAfter,
        ),
      RedesignCategory.garden => (
          before: cardGardenBefore,
          after: cardGardenAfter,
        ),
      RedesignCategory.floor => (
          before: cardFloorBefore,
          after: cardFloorAfter,
        ),
    };
  }

  static String styleImage({
    required RedesignCategory category,
    required String styleId,
    String extension = 'jpeg',
  }) {
    return 'assets/styles/${category.assetsFolder}/$styleId.$extension';
  }
}
