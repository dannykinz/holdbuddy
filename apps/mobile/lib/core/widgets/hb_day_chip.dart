import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import '../l10n/generated/app_localizations.dart';
import 'hb_day_status.dart';
import 'hb_hatch.dart';

class HbDayChip extends StatelessWidget {
  const HbDayChip({
    super.key,
    required this.weekday,
    required this.day,
    required this.dateLabel,
    required this.status,
    this.onPressed,
  });
  final String weekday;
  final String day;
  final String dateLabel;
  final HbDayStatus status;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Semantics(
      label: AppLocalizations.of(context)
          .calendarDay(dateLabel, status.label(AppLocalizations.of(context))),
      selected: status == HbDayStatus.today,
      excludeSemantics: true,
      button: onPressed != null,
      onTap: onPressed,
      child: SizedBox(
        width: Tokens.minTouchTarget,
        height: WidgetTokens.dayHeight,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(
              Tokens.minTouchTarget,
              WidgetTokens.dayHeight,
            ),
          ),
          child: _face(colors),
        ),
      ),
    );
  }

  Widget _face(AppColors colors) {
    final isToday = status == HbDayStatus.today;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Tokens.radiusField),
      child: Container(
        width: WidgetTokens.dayWidth,
        height: WidgetTokens.dayHeight,
        color: isToday
            ? colors.text
            : status == HbDayStatus.rest
            ? null
            : colors.soft,
        child: Stack(
          children: [
            if (status == HbDayStatus.missed)
              Positioned.fill(child: HbHatch(color: colors.subtle)),
            Center(child: _labels(colors)),
          ],
        ),
      ),
    );
  }

  Widget _labels(AppColors colors) => Column(
    mainAxisSize: MainAxisSize.min,
    spacing: WidgetTokens.dayGap,
    children: [
      Text(
        weekday,
        style: WidgetTokens.dayLabel.copyWith(
          color: status == HbDayStatus.today ? colors.surface : colors.subtle,
        ),
      ),
      Text(
        day,
        style: WidgetTokens.dayNumber.copyWith(color: _numberColor(colors)),
      ),
      Container(
        width: WidgetTokens.dayDot,
        height: WidgetTokens.dayDot,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _dotColor(colors),
        ),
      ),
    ],
  );

  Color _numberColor(AppColors colors) => switch (status) {
    HbDayStatus.today => colors.surface,
    HbDayStatus.missed => colors.muted,
    HbDayStatus.rest => colors.subtle,
    _ => colors.text,
  };

  Color _dotColor(AppColors colors) => switch (status) {
    HbDayStatus.done => colors.green,
    HbDayStatus.today => colors.accent,
    HbDayStatus.planned => colors.subtle,
    _ => colors.surface.withValues(alpha: WidgetTokens.hiddenOpacity),
  };
}
