import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/deadline.dart';
import '../../domain/deadline_schedule.dart';
import '../../domain/deadline_status.dart';
import '../deadline_copy.dart';

class DeadlineTimeline extends StatelessWidget {
  const DeadlineTimeline({super.key, required this.deadline});
  final Deadline deadline;
  @override
  Widget build(BuildContext context) => Card.outlined(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(DeadlineTokens.cardRadius),
      side: BorderSide(color: AppColors.of(context).line),
    ),
    child: Padding(
      padding: const EdgeInsets.all(Tokens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Tokens.space12,
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
              Text(
                AppLocalizations.of(context).deadlineTitle,
                style: Tokens.strong,
              ),
            ],
          ),
          for (final offset in deadline.stops) _stop(context, offset),
        ],
      ),
    ),
  );
  int? get _next {
    if (deadline.status != DeadlineStatus.upcoming) return null;
    for (final offset in deadline.stops) {
      final date = DeadlineSchedule.stopDate(deadline.dueAt, offset);
      if (!deadline.disabledStops.contains(offset) &&
          DeadlineSchedule.daysBetween(date, DateTime.now()) >= 0)
        return offset;
    }
    return null;
  }

  Widget _stop(BuildContext context, int offset) {
    final colors = AppColors.of(context);
    final date = DeadlineSchedule.stopDate(deadline.dueAt, offset);
    final passed = DeadlineSchedule.daysBetween(date, DateTime.now()) < 0;
    final off =
        deadline.disabledStops.contains(offset) ||
        deadline.status != DeadlineStatus.upcoming;
    final label = _status(context, offset, off, passed);
    return Row(
      spacing: Tokens.space8,
      children: [
        Expanded(
          child: Text(
            DeadlineCopy.stop(AppLocalizations.of(context), offset),
            style: Tokens.label.copyWith(
              color: off || passed ? colors.subtle : colors.text,
              decoration: off || passed ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        Text(
          DateFormat.MMMd(AppLocalizations.of(context).localeName).format(date),
          style: Tokens.label.copyWith(color: colors.muted),
        ),
        if (label != null) _badge(context, label, offset == _next),
      ],
    );
  }

  String? _status(BuildContext context, int offset, bool off, bool passed) {
    final l = AppLocalizations.of(context);
    if (off) return l.deadlineOff;
    if (passed) return l.deadlinePassed;
    return offset == _next ? l.deadlineNext : null;
  }

  Widget _badge(BuildContext context, String label, bool next) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Tokens.space8,
        vertical: DeadlineTokens.copyGap,
      ),
      decoration: ShapeDecoration(
        color: next ? colors.skySoft : colors.soft,
        shape: Tokens.chipShape,
      ),
      child: Text(
        label,
        style: DeadlineTokens.badge.copyWith(
          color: next ? colors.sky : colors.subtle,
        ),
      ),
    );
  }
}
