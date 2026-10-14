import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/fakes/fake_onboarding_data.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_progress_bar.dart';
import 'preview_card.dart';
import 'preview_icon.dart';

class PreviewProgressCard extends StatelessWidget {
  const PreviewProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return PreviewCard(
      padding: const EdgeInsets.all(OnboardingTokens.bottomInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Tokens.space12,
        children: [
          _heading(colors, l10n),
          _count(colors, l10n),
          const HbProgressBar(
            done: FakeOnboardingData.completedChapters,
            thisWeek: FakeOnboardingData.weekChapters,
            total: FakeOnboardingData.totalChapters,
            label: '',
          ),
          _stats(colors, l10n),
        ],
      ),
    );
  }

  Widget _heading(AppColors colors, AppLocalizations l10n) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        l10n.previewOnPace(FakeOnboardingData.planName),
        style: Tokens.label.copyWith(color: colors.muted),
      ),
      Row(
        spacing: Tokens.navGap,
        children: [
          Text(
            l10n.progress,
            style: WidgetTokens.chipLabel.copyWith(color: colors.accent),
          ),
          PreviewIcon(
            asset: 'assets/icons/onboarding_chevron.svg',
            color: colors.accent,
          ),
        ],
      ),
    ],
  );

  Widget _count(AppColors colors, AppLocalizations l10n) => Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    spacing: Tokens.space8,
    children: [
      Text(
        NumberFormat.decimalPattern(l10n.localeName)
            .format(FakeOnboardingData.completedChapters),
        style: OnboardingTokens.previewCount.copyWith(color: colors.text),
      ),
      Text(
        l10n.previewChapters(FakeOnboardingData.totalChapters),
        style: WidgetTokens.nodeNumber.copyWith(color: colors.subtle),
      ),
    ],
  );

  Widget _stats(AppColors colors, AppLocalizations l10n) => Row(
    spacing: OnboardingTokens.bottomInset,
    children: [
      _stat(
        'flag',
        DateFormat(
          'd MMM',
          l10n.localeName,
        ).format(FakeOnboardingData.previousFinish),
        colors.text,
        colors.text,
      ),
      _stat(
        'clock',
        l10n.previewStudied(FakeOnboardingData.studyHours),
        colors.sky,
        colors.text,
      ),
      _stat(
        'pen',
        l10n.previewNotes(FakeOnboardingData.notes),
        colors.purple,
        colors.text,
      ),
    ],
  );

  Widget _stat(String icon, String label, Color color, Color textColor) => Row(
    spacing: WidgetTokens.stepGap,
    children: [
      PreviewIcon(asset: 'assets/icons/onboarding_$icon.svg', color: color),
      Text(label, style: WidgetTokens.chipLabel.copyWith(color: textColor)),
    ],
  );
}
