import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/deadline_schedule.dart';
import '../deadline_copy.dart';

class DeadlineSchedulePreview extends StatelessWidget {
  const DeadlineSchedulePreview({
    super.key,
    required this.dueAt,
    required this.stops,
    required this.disabled,
    required this.onToggle,
  });
  final DateTime dueAt;
  final List<int> stops;
  final List<int> disabled;
  final ValueChanged<int> onToggle;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final days = DeadlineSchedule.daysBetween(dueAt, DateTime.now());
    return Container(
      padding: const EdgeInsets.all(Tokens.space16),
      decoration: BoxDecoration(
        color: AppColors.of(context).skySoft,
        borderRadius: BorderRadius.circular(DeadlineTokens.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: DeadlineTokens.copyGap,
        children: [
          Row(
            spacing: Tokens.space8,
            children: [
              SvgPicture.asset(
                'assets/icons/reminder_bell.svg',
                excludeFromSemantics: true,
                colorFilter: ColorFilter.mode(
                  AppColors.of(context).sky,
                  BlendMode.srcIn,
                ),
              ),
              Expanded(
                child: Text(
                  stops.first > 3
                      ? l.deadlineWeeklyRule(days)
                      : l.deadlineDailyRule(days),
                  style: Tokens.label.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.of(context).text,
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: DeadlineTokens.stopGap,
            children: [for (final offset in stops) _stop(context, offset)],
          ),
        ],
      ),
    );
  }

  Widget _stop(BuildContext context, int offset) {
    final l = AppLocalizations.of(context);
    final off = disabled.contains(offset);
    final label = offset == 0
        ? l.deadlineOnDay
        : offset >= 7
        ? l.deadlineWeeks(offset ~/ 7)
        : l.deadlineDays(offset);
    return Semantics(
      toggled: !off,
      label: DeadlineCopy.stop(l, offset),
      child: TextButton(
        onPressed: () => onToggle(offset),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, Tokens.minTouchTarget),
        ),
        child: _stopFace(context, label, off),
      ),
    );
  }

  Widget _stopFace(BuildContext context, String label, bool off) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Tokens.space8,
        vertical: DeadlineTokens.copyGap,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: off ? colors.line : colors.sky,
          width: DeadlineTokens.stopBorder,
        ),
        borderRadius: BorderRadius.circular(DeadlineTokens.stopRadius),
      ),
      child: Text(
        label,
        style: DeadlineTokens.stopLabel.copyWith(
          color: off ? colors.subtle : colors.sky,
          decoration: off ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
