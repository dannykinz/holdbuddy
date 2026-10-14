import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/fakes/fake_onboarding_data.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import 'preview_card.dart';
import 'preview_icon.dart';

class PreviewSessionCard extends StatelessWidget {
  const PreviewSessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return PreviewCard(
      radius: Tokens.radiusSheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Tokens.space16,
        children: [
          _time(colors, l10n),
          _chapter(colors, l10n),
          Row(
            spacing: WidgetTokens.buttonGap,
            children: [
              Expanded(child: _tasks(colors, l10n)),
              Expanded(child: _note(colors, l10n)),
            ],
          ),
          _sessionAction(colors, l10n),
        ],
      ),
    );
  }

  Widget _time(AppColors colors, AppLocalizations l10n) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tonight,
            style: WidgetTokens.chipLabel.copyWith(color: colors.orange),
          ),
          Text(
            l10n.previewStartsIn,
            style: Tokens.meta.copyWith(color: colors.subtle),
          ),
        ],
      ),
      _clock(colors),
    ],
  );

  Widget _clock(AppColors colors) => Text.rich(
    const TextSpan(
      children: [
        TextSpan(text: FakeOnboardingData.sessionTime),
        TextSpan(
          text: FakeOnboardingData.period,
          style: OnboardingTokens.previewPeriod,
        ),
      ],
    ),
    style: OnboardingTokens.previewTime.copyWith(color: colors.text),
  );

  Widget _chapter(AppColors colors, AppLocalizations l10n) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: WidgetTokens.dayGap,
    children: [
      Text(
        FakeOnboardingData.chapterName,
        style: Tokens.title.copyWith(color: colors.text),
      ),
      Text(
        l10n.previewChapterSummary(FakeOnboardingData.planName),
        style: Tokens.small.copyWith(color: colors.muted),
      ),
    ],
  );

  Widget _tasks(AppColors colors, AppLocalizations l10n) => _subCard(
    colors.soft,
    colors.subtle,
    l10n.tasksLabel,
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: WidgetTokens.stepGap,
      children: [
        _subRow(
          l10n.previewTasks(
            FakeOnboardingData.completedTasks,
            FakeOnboardingData.tasks,
          ),
          colors.text,
          colors.subtle,
        ),
        _taskSegments(colors),
      ],
    ),
  );

  Widget _taskSegments(AppColors colors) => Row(
    spacing: WidgetTokens.progressGap,
    children: [
      for (var index = 0; index < FakeOnboardingData.tasks; index++)
        Expanded(
          child: Container(
            height: WidgetTokens.sheetHandleHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(WidgetTokens.stepRadius),
              color: index < FakeOnboardingData.completedTasks
                  ? colors.green
                  : colors.line,
            ),
          ),
        ),
    ],
  );

  Widget _note(AppColors colors, AppLocalizations l10n) => _subCard(
    colors.purpleSoft,
    colors.purple,
    l10n.noteLabel,
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: WidgetTokens.stepGap,
      children: [
        _subRow(l10n.writeOne, colors.text, colors.purple),
        PreviewIcon(
          asset: 'assets/icons/onboarding_pen.svg',
          color: colors.purple,
          size: const Size.square(OnboardingTokens.previewPenSize),
        ),
      ],
    ),
  );

  Widget _subCard(
    Color background,
    Color labelColor,
    String label,
    Widget child,
  ) => Container(
    padding: const EdgeInsets.all(WidgetTokens.chipHorizontal),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(Tokens.space20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: WidgetTokens.stepGap,
      children: [
        Text(label, style: Tokens.dataLabel.copyWith(color: labelColor)),
        child,
      ],
    ),
  );

  Widget _subRow(String label, Color text, Color icon) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: OnboardingTokens.nudgeMessage.copyWith(color: text)),
      PreviewIcon(asset: 'assets/icons/onboarding_chevron.svg', color: icon),
    ],
  );

  Widget _sessionAction(AppColors colors, AppLocalizations l10n) => Container(
    height: Tokens.buttonHeight,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: colors.primary,
      borderRadius: BorderRadius.circular(Tokens.radiusButton),
      boxShadow: [
        BoxShadow(
          color: colors.primaryEdge,
          offset: const Offset(0, WidgetTokens.buttonEdge),
        ),
      ],
    ),
    child: Text(
      l10n.startSession,
      style: Tokens.strong.copyWith(color: colors.onPrimary),
    ),
  );
}
