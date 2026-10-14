import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../deadlines/domain/deadline.dart';
import '../../../deadlines/domain/deadline_schedule.dart';
import '../deadline_copy.dart';

class DeadlineStops extends StatelessWidget {
  const DeadlineStops({super.key, required this.deadline});
  final Deadline deadline;
  @override
  Widget build(BuildContext context) => Row(
    spacing: Tokens.space8,
    children: [
      SvgPicture.asset(
        'assets/icons/reminder_bell_small.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(
          AppColors.of(context).subtle,
          BlendMode.srcIn,
        ),
      ),
      Flexible(
        child: Wrap(
          spacing: DeadlineTokens.stopGap,
          runSpacing: DeadlineTokens.stopGap,
          children: [
            for (final offset in deadline.stops) _stop(context, offset),
          ],
        ),
      ),
    ],
  );
  Widget _stop(BuildContext context, int offset) {
    final colors = AppColors.of(context);
    final pair = DeadlineCopy.color(deadline.dueAt).colors(colors);
    final date = DeadlineSchedule.stopDate(deadline.dueAt, offset);
    final passed = DeadlineSchedule.daysBetween(date, DateTime.now()) < 0;
    final off = deadline.disabledStops.contains(offset);
    final highlighted = !off && !passed && offset == 0;
    return Container(
      constraints: BoxConstraints(
        minWidth: offset == 0
            ? DeadlineTokens.stopDayWidth
            : DeadlineTokens.stopWidth,
      ),
      padding: const EdgeInsets.symmetric(horizontal: DeadlineTokens.stopGap),
      decoration: BoxDecoration(
        border: Border.all(
          color: highlighted ? pair.strong : colors.line,
          width: DeadlineTokens.stopBorder,
        ),
        borderRadius: BorderRadius.circular(DeadlineTokens.stopRadius),
      ),
      child: _label(
        context,
        offset,
        highlighted ? pair.strong : colors.subtle,
        off,
      ),
    );
  }

  Widget _label(BuildContext context, int offset, Color color, bool off) =>
      Text(
        DeadlineCopy.stop(AppLocalizations.of(context), offset, short: true),
        textAlign: TextAlign.center,
        style: DeadlineTokens.stopLabel.copyWith(
          color: color,
          decoration: off ? TextDecoration.lineThrough : null,
        ),
      );
}
