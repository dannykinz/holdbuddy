import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/fakes/fake_onboarding_data.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import 'illustration_stage.dart';
import 'preview_card.dart';
import 'preview_week.dart';

class ReturnIllustration extends StatelessWidget {
  const ReturnIllustration({super.key});

  @override
  Widget build(BuildContext context) => IllustrationStage(
    child: Stack(
      clipBehavior: Clip.none,
      children: [_week(), _recalculated(context)],
    ),
  );

  Widget _week() => Positioned(
    left: OnboardingTokens.weekPosition.dx,
    top: OnboardingTokens.weekPosition.dy,
    width: OnboardingTokens.weekBounds.width,
    height: OnboardingTokens.weekBounds.height,
    child: Center(
      child: Transform.rotate(
        angle: OnboardingTokens.sessionAngle,
        child: const SizedBox(
          width: OnboardingTokens.weekWidth,
          child: FittedBox(
            child: SizedBox(
              width: OnboardingTokens.canvasWidth,
              child: PreviewCard(
                padding: EdgeInsets.all(OnboardingTokens.bottomInset),
                child: PreviewWeek(),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _recalculated(BuildContext context) => Positioned(
    left: OnboardingTokens.recalculatedPosition.dx,
    top: OnboardingTokens.recalculatedPosition.dy,
    width: OnboardingTokens.recalculatedBounds.width,
    height: OnboardingTokens.recalculatedBounds.height,
    child: Center(
      child: Transform.rotate(
        angle: OnboardingTokens.returnAngle,
        child: SizedBox(
          width: OnboardingTokens.recalculatedWidth,
          child: PreviewCard(
            radius: OnboardingTokens.recalculatedRadius,
            padding: const EdgeInsets.symmetric(
              horizontal: Tokens.navItemRadius,
              vertical: Tokens.space20,
            ),
            child: _finishDate(context),
          ),
        ),
      ),
    ),
  );

  Widget _finishDate(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final format = DateFormat('d MMMM', l10n.localeName);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: WidgetTokens.stepGap,
      children: [
        _chip(colors, l10n),
        const SizedBox(height: WidgetTokens.stepGap),
        Text(
          l10n.newFinishDate,
          style: OnboardingTokens.finishLabel.copyWith(color: colors.subtle),
        ),
        FittedBox(
          child: Text(
            format.format(FakeOnboardingData.newFinish),
            style: OnboardingTokens.finishDate.copyWith(color: colors.text),
          ),
        ),
        _previousDate(colors, l10n, format),
      ],
    );
  }

  Widget _previousDate(
    AppColors colors,
    AppLocalizations l10n,
    DateFormat format,
  ) => Text.rich(
    TextSpan(
      children: [
        TextSpan(text: l10n.previously),
        TextSpan(
          text: format.format(FakeOnboardingData.previousFinish),
          style: const TextStyle(decoration: TextDecoration.lineThrough),
        ),
      ],
    ),
    style: OnboardingTokens.finishMeta.copyWith(color: colors.muted),
  );

  Widget _chip(AppColors colors, AppLocalizations l10n) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: Tokens.space8,
      vertical: WidgetTokens.stepGap,
    ),
    decoration: ShapeDecoration(
      color: colors.greenSoft,
      shape: Tokens.chipShape,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: WidgetTokens.stepGap,
      children: [
        SvgPicture.asset(
          'assets/icons/onboarding_refresh.svg',
          colorFilter: ColorFilter.mode(colors.green, BlendMode.srcIn),
        ),
        Text(
          l10n.planRecalculated,
          style: OnboardingTokens.finishChip.copyWith(color: colors.green),
        ),
      ],
    ),
  );
}
