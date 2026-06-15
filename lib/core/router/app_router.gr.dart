// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AppBootstrapPage]
class AppBootstrapRoute extends PageRouteInfo<void> {
  const AppBootstrapRoute({List<PageRouteInfo>? children})
    : super(AppBootstrapRoute.name, initialChildren: children);

  static const String name = 'AppBootstrapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppBootstrapPage();
    },
  );
}

/// generated route for
/// [ForceUpdatePage]
class ForceUpdateRoute extends PageRouteInfo<void> {
  const ForceUpdateRoute({List<PageRouteInfo>? children})
    : super(ForceUpdateRoute.name, initialChildren: children);

  static const String name = 'ForceUpdateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForceUpdatePage();
    },
  );
}

/// generated route for
/// [GalleryDetailPage]
class GalleryDetailRoute extends PageRouteInfo<GalleryDetailRouteArgs> {
  GalleryDetailRoute({
    Key? key,
    required int designId,
    List<PageRouteInfo>? children,
  }) : super(
         GalleryDetailRoute.name,
         args: GalleryDetailRouteArgs(key: key, designId: designId),
         initialChildren: children,
       );

  static const String name = 'GalleryDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GalleryDetailRouteArgs>();
      return GalleryDetailPage(key: args.key, designId: args.designId);
    },
  );
}

class GalleryDetailRouteArgs {
  const GalleryDetailRouteArgs({this.key, required this.designId});

  final Key? key;

  final int designId;

  @override
  String toString() {
    return 'GalleryDetailRouteArgs{key: $key, designId: $designId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GalleryDetailRouteArgs) return false;
    return key == other.key && designId == other.designId;
  }

  @override
  int get hashCode => key.hashCode ^ designId.hashCode;
}

/// generated route for
/// [GalleryPage]
class GalleryRoute extends PageRouteInfo<void> {
  const GalleryRoute({List<PageRouteInfo>? children})
    : super(GalleryRoute.name, initialChildren: children);

  static const String name = 'GalleryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GalleryPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [MainShellPage]
class MainShellRoute extends PageRouteInfo<void> {
  const MainShellRoute({List<PageRouteInfo>? children})
    : super(MainShellRoute.name, initialChildren: children);

  static const String name = 'MainShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainShellPage();
    },
  );
}

/// generated route for
/// [OnboardingPage]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingPage();
    },
  );
}

/// generated route for
/// [PaywallPage]
class PaywallRoute extends PageRouteInfo<void> {
  const PaywallRoute({List<PageRouteInfo>? children})
    : super(PaywallRoute.name, initialChildren: children);

  static const String name = 'PaywallRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PaywallPage();
    },
  );
}

/// generated route for
/// [RedesignFlowPage]
class RedesignFlowRoute extends PageRouteInfo<RedesignFlowRouteArgs> {
  RedesignFlowRoute({
    Key? key,
    required RedesignCategory category,
    List<PageRouteInfo>? children,
  }) : super(
         RedesignFlowRoute.name,
         args: RedesignFlowRouteArgs(key: key, category: category),
         initialChildren: children,
       );

  static const String name = 'RedesignFlowRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RedesignFlowRouteArgs>();
      return RedesignFlowPage(key: args.key, category: args.category);
    },
  );
}

class RedesignFlowRouteArgs {
  const RedesignFlowRouteArgs({this.key, required this.category});

  final Key? key;

  final RedesignCategory category;

  @override
  String toString() {
    return 'RedesignFlowRouteArgs{key: $key, category: $category}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RedesignFlowRouteArgs) return false;
    return key == other.key && category == other.category;
  }

  @override
  int get hashCode => key.hashCode ^ category.hashCode;
}

/// generated route for
/// [RedesignGeneratingPage]
class RedesignGeneratingRoute
    extends PageRouteInfo<RedesignGeneratingRouteArgs> {
  RedesignGeneratingRoute({
    Key? key,
    required RedesignCategory category,
    required String imagePath,
    required String styleId,
    required String paletteId,
    String? wishes,
    List<PageRouteInfo>? children,
  }) : super(
         RedesignGeneratingRoute.name,
         args: RedesignGeneratingRouteArgs(
           key: key,
           category: category,
           imagePath: imagePath,
           styleId: styleId,
           paletteId: paletteId,
           wishes: wishes,
         ),
         initialChildren: children,
       );

  static const String name = 'RedesignGeneratingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RedesignGeneratingRouteArgs>();
      return RedesignGeneratingPage(
        key: args.key,
        category: args.category,
        imagePath: args.imagePath,
        styleId: args.styleId,
        paletteId: args.paletteId,
        wishes: args.wishes,
      );
    },
  );
}

class RedesignGeneratingRouteArgs {
  const RedesignGeneratingRouteArgs({
    this.key,
    required this.category,
    required this.imagePath,
    required this.styleId,
    required this.paletteId,
    this.wishes,
  });

  final Key? key;

  final RedesignCategory category;

  final String imagePath;

  final String styleId;

  final String paletteId;

  final String? wishes;

  @override
  String toString() {
    return 'RedesignGeneratingRouteArgs{key: $key, category: $category, imagePath: $imagePath, styleId: $styleId, paletteId: $paletteId, wishes: $wishes}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RedesignGeneratingRouteArgs) return false;
    return key == other.key &&
        category == other.category &&
        imagePath == other.imagePath &&
        styleId == other.styleId &&
        paletteId == other.paletteId &&
        wishes == other.wishes;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      category.hashCode ^
      imagePath.hashCode ^
      styleId.hashCode ^
      paletteId.hashCode ^
      wishes.hashCode;
}

/// generated route for
/// [RedesignResultPage]
class RedesignResultRoute extends PageRouteInfo<RedesignResultRouteArgs> {
  RedesignResultRoute({
    Key? key,
    required RedesignCategory category,
    required String beforePath,
    required String afterPath,
    List<PageRouteInfo>? children,
  }) : super(
         RedesignResultRoute.name,
         args: RedesignResultRouteArgs(
           key: key,
           category: category,
           beforePath: beforePath,
           afterPath: afterPath,
         ),
         initialChildren: children,
       );

  static const String name = 'RedesignResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RedesignResultRouteArgs>();
      return RedesignResultPage(
        key: args.key,
        category: args.category,
        beforePath: args.beforePath,
        afterPath: args.afterPath,
      );
    },
  );
}

class RedesignResultRouteArgs {
  const RedesignResultRouteArgs({
    this.key,
    required this.category,
    required this.beforePath,
    required this.afterPath,
  });

  final Key? key;

  final RedesignCategory category;

  final String beforePath;

  final String afterPath;

  @override
  String toString() {
    return 'RedesignResultRouteArgs{key: $key, category: $category, beforePath: $beforePath, afterPath: $afterPath}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RedesignResultRouteArgs) return false;
    return key == other.key &&
        category == other.category &&
        beforePath == other.beforePath &&
        afterPath == other.afterPath;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      category.hashCode ^
      beforePath.hashCode ^
      afterPath.hashCode;
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
}
