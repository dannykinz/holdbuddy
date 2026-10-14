import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_hatch.dart';
import '../../domain/progress_day.dart';
import '../../domain/progress_period.dart';
import '../../logic/progress_controller.dart';

class ProgressChart extends ConsumerWidget {
  const ProgressChart({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(progressSnapshotProvider);
    final period = ref.watch(ProgressController.provider);
    final maximum = data.days.fold<int>(
      1,
      (value, day) => day.minutes > value ? day.minutes : value,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: DailyTokens.rowGap,
        children: [
          for (final day in data.days) _day(context, day, maximum, period),
        ],
      ),
    );
  }

  Widget _day(
    BuildContext context,
    ProgressDay day,
    int maximum,
    ProgressPeriod period,
  ) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: ProgressTokens.chartWidth,
      child: Column(
        spacing: Tokens.space8,
        children: [
          _weekday(context, day, period),
          Text(
            day.date.day.toString(),
            style: Tokens.label.copyWith(
              color: day.current ? colors.text : colors.muted,
            ),
          ),
          Text(
            day.minutes > 0 ? l10n.progressMinutes(day.minutes) : '',
            style: Tokens.meta.copyWith(color: colors.subtle),
          ),
          _track(context, day, maximum),
        ],
      ),
    );
  }

  Widget _weekday(
    BuildContext context,
    ProgressDay day,
    ProgressPeriod period,
  ) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Text(
      DateFormat(
        period == ProgressPeriod.week ? 'EEE' : 'MMM',
        l10n.localeName,
      ).format(day.date).toUpperCase(),
      style: Tokens.dataLabel.copyWith(
        color: day.current ? colors.accent : colors.subtle,
      ),
    );
  }

  Widget _track(BuildContext context, ProgressDay day, int maximum) {
    final colors = AppColors.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(ProgressTokens.chartRadius),
      child: Container(
        width: ProgressTokens.chartWidth,
        height: ProgressTokens.chartHeight,
        color: colors.soft,
        alignment: Alignment.bottomCenter,
        child: day.missed
            ? HbHatch(color: colors.subtle, child: const SizedBox.expand())
            : _filledTrack(context, day, maximum),
      ),
    );
  }

  Widget _filledTrack(BuildContext context, ProgressDay day, int maximum) {
    final colors = AppColors.of(context);
    return SizedBox(
      height: ProgressTokens.chartHeight * day.minutes / maximum,
      child: ColoredBox(
        color: colors.accent.withValues(
          alpha: day.current ? 1 : ProgressTokens.pastOpacity,
        ),
        child: HbHatch(color: colors.surface, child: const SizedBox.expand()),
      ),
    );
  }
}
