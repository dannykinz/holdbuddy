import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/fakes/fake_onboarding_data.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import 'preview_icon.dart';

class PreviewTodayHeader extends StatelessWidget {
  const PreviewTodayHeader({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      _status(AppColors.of(context)),
      const SizedBox(height: Tokens.space16),
      _date(context),
    ],
  );

  Widget _status(AppColors colors) => Row(
    spacing: Tokens.space8,
    children: [
      Expanded(
        child: Text(
          FakeOnboardingData.clock,
          style: Tokens.small.copyWith(color: colors.text),
        ),
      ),
      PreviewIcon(asset: 'assets/icons/preview_signal.svg', color: colors.text),
      PreviewIcon(
        asset: 'assets/icons/preview_battery.svg',
        color: colors.text,
        size: const Size(Tokens.navItemRadius, Tokens.space16),
      ),
    ],
  );

  Widget _date(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      spacing: WidgetTokens.buttonGap,
      children: [
        Expanded(child: _dateLabel(context)),
        _comebacks(colors),
        _alerts(colors),
      ],
    );
  }

  Widget _comebacks(AppColors colors) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: WidgetTokens.chipHorizontal,
      vertical: Tokens.space8,
    ),
    decoration: ShapeDecoration(
      color: colors.greenSoft,
      shape: Tokens.chipShape,
    ),
    child: Row(
      spacing: WidgetTokens.stepGap,
      children: [
        PreviewIcon(
          asset: 'assets/icons/onboarding_refresh.svg',
          color: colors.green,
        ),
        Text(
          '${FakeOnboardingData.comebacks}',
          style: OnboardingTokens.nudgeMessage.copyWith(color: colors.green),
        ),
      ],
    ),
  );

  Widget _alerts(AppColors colors) => Stack(
    clipBehavior: Clip.none,
    children: [
      _alertsFace(colors),
      Positioned(
        right: -WidgetTokens.activeWidth,
        top: -WidgetTokens.activeWidth,
        child: Container(
          width: OnboardingTokens.alertBadgeSize,
          height: OnboardingTokens.alertBadgeSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.pink,
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.surface,
              width: WidgetTokens.activeWidth,
            ),
          ),
          child: Text(
            '${FakeOnboardingData.unreadAlerts}',
            style: WidgetTokens.dayLabel.copyWith(color: colors.onPrimary),
          ),
        ),
      ),
    ],
  );

  Widget _alertsFace(AppColors colors) => Container(
    width: Tokens.navItemHeight,
    height: Tokens.navItemHeight,
    decoration: BoxDecoration(
      color: colors.soft,
      borderRadius: BorderRadius.circular(Tokens.navItemRadius),
    ),
    alignment: Alignment.center,
    child: PreviewIcon(
      asset: 'assets/icons/preview_bell.svg',
      color: colors.text,
      size: const Size.square(Tokens.space20),
    ),
  );

  Widget _dateLabel(BuildContext context) {
    final colors = AppColors.of(context);
    final month = DateFormat.MMM(AppLocalizations.of(context).localeName)
        .format(FakeOnboardingData.phoneDate);
    return Row(
      spacing: WidgetTokens.stepGap,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: FakeOnboardingData.previewDate),
              TextSpan(text: ' $month', style: Tokens.title),
            ],
          ),
          style: OnboardingTokens.previewDate.copyWith(color: colors.text),
        ),
        PreviewIcon(
          asset: 'assets/icons/preview_down.svg',
          color: colors.subtle,
        ),
      ],
    );
  }
}
