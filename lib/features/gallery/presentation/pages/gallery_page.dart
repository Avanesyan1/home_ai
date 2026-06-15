import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/router/app_router.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/core/widgets/app_background.dart';
import 'package:home_ai/features/gallery/data/gallery_repository.dart';
import 'package:home_ai/features/gallery/domain/entities/saved_design.dart';
import 'package:home_ai/features/gallery/presentation/widgets/gallery_grid_item.dart';

@RoutePage()
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return CupertinoPageScaffold(
      key: ValueKey(locale.languageCode),
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        automaticallyImplyLeading: false,
        middle: Text(
          LocaleKeys.galleryTitle.tr(),
          style: AppTextStyles.headline,
        ),
      ),
      child: AppBackground(
        child: SafeArea(
          bottom: false,
          child: StreamBuilder<List<SavedDesign>>(
            stream: GalleryRepository.instance.watchAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Center(child: CupertinoActivityIndicator());
              }

              final designs = snapshot.data ?? const [];

              if (designs.isEmpty) {
                return _EmptyState();
              }

              return GridView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.lg,
                  AppSpacing.screenHorizontal,
                  AppSpacing.xxl,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1,
                ),
                itemCount: designs.length,
                itemBuilder: (context, index) {
                  final design = designs[index];
                  return GalleryGridItem(
                    design: design,
                    onTap: () => context.router.push(
                      GalleryDetailRoute(designId: design.id),
                    ),
                  ).animateStagger(index, stepMs: 60);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.photo_on_rectangle,
              size: 56,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              LocaleKeys.galleryEmptyTitle.tr(),
              style: AppTextStyles.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              LocaleKeys.galleryEmptySubtitle.tr(),
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animateFadeScale();
  }
}
