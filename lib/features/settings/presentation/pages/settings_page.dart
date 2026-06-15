import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/config/app_links.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/l10n/locale_labels.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/widgets/app_background.dart';
import 'package:home_ai/features/settings/presentation/utils/settings_actions.dart';
import 'package:home_ai/features/settings/presentation/widgets/language_picker_sheet.dart';
import 'package:home_ai/features/settings/presentation/widgets/settings_nav_bar.dart';
import 'package:home_ai/features/settings/presentation/widgets/settings_pro_banner.dart';
import 'package:home_ai/features/settings/presentation/widgets/settings_section.dart';
import 'package:home_ai/features/settings/presentation/widgets/settings_tile.dart';
import 'package:home_ai/features/settings/presentation/widgets/settings_version_tile.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return CupertinoPageScaffold(
      key: ValueKey(locale.languageCode),
      backgroundColor: AppColors.background,
      child: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SettingsNavBar(),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                      ),
                      child: Column(
                        children: [
                          SettingsProBanner(),
                          SettingsSection(
                            titleKey: LocaleKeys.settingsSectionGeneral,
                            children: [
                              SettingsTile(
                                title: LocaleKeys.settingsLanguage.tr(),
                                subtitle: context.locale.label,
                                icon: CupertinoIcons.globe,
                                iconColor: AppColors.iconLanguage,
                                iconBackground: AppColors.iconLanguageBg,
                                onTap: () =>
                                    LanguagePickerSheet.show(context),
                                showDivider: false,
                              ),
                            ],
                          ).animateStagger(1),
                          SettingsSection(
                            titleKey: LocaleKeys.settingsSectionAbout,
                            children: [
                              SettingsTile(
                                title: LocaleKeys.settingsRateApp.tr(),
                                icon: CupertinoIcons.star_fill,
                                iconColor: AppColors.iconRate,
                                iconBackground: AppColors.iconRateBg,
                                onTap: () => SettingsActions.openLink(
                                  context,
                                  AppLinks.appStoreReview,
                                ),
                              ),
                              SettingsTile(
                                title: LocaleKeys.settingsSupport.tr(),
                                icon: CupertinoIcons.chat_bubble_2_fill,
                                iconColor: AppColors.iconSupport,
                                iconBackground: AppColors.iconSupportBg,
                                onTap: () => SettingsActions.openLink(
                                  context,
                                  AppLinks.support,
                                ),
                              ),
                              SettingsVersionTile(),
                            ],
                          ).animateStagger(2),
                          SettingsSection(
                            titleKey: LocaleKeys.settingsSectionLegal,
                            children: [
                              SettingsTile(
                                title:
                                    LocaleKeys.settingsPrivacyPolicy.tr(),
                                icon: CupertinoIcons.lock_shield_fill,
                                iconColor: AppColors.iconPrivacy,
                                iconBackground: AppColors.iconPrivacyBg,
                                onTap: () => SettingsActions.openLink(
                                  context,
                                  AppLinks.privacy,
                                ),
                              ),
                              SettingsTile(
                                title:
                                    LocaleKeys.settingsTermsOfService.tr(),
                                icon: CupertinoIcons.doc_text_fill,
                                iconColor: AppColors.iconTerms,
                                iconBackground: AppColors.iconTermsBg,
                                onTap: () => SettingsActions.openLink(
                                  context,
                                  AppLinks.terms,
                                ),
                                showDivider: false,
                              ),
                            ],
                          ).animateStagger(3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
