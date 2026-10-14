import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/deadline_schedule.dart';

class DeadlineCalendar extends StatefulWidget {
  const DeadlineCalendar({
    super.key,
    required this.selected,
    required this.onSelected,
  });
  final DateTime selected;
  final ValueChanged<DateTime> onSelected;
  @override
  State<DeadlineCalendar> createState() => _DeadlineCalendarState();
}

class _DeadlineCalendarState extends State<DeadlineCalendar> {
  late DateTime _month = DateTime(widget.selected.year, widget.selected.month);
  @override
  Widget build(BuildContext context) => Card.outlined(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(DeadlineTokens.cardRadius),
      side: BorderSide(color: AppColors.of(context).line),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: Tokens.space8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: math.max(
            DeadlineTokens.calendarWidth,
            MediaQuery.sizeOf(context).width - Tokens.screenMargin * 2,
          ),
          child: Column(
            children: [
              _header(context),
              _weekdays(context),
              ..._weeks(context),
            ],
          ),
        ),
      ),
    ),
  );
  Widget _header(BuildContext context) => Row(
    children: [
      _monthAction(context, previous: true),
      Expanded(
        child: Text(
          DateFormat.yMMMM(AppLocalizations.of(context).localeName)
              .format(_month),
          textAlign: TextAlign.center,
          style: Tokens.strong,
        ),
      ),
      _monthAction(context, previous: false),
    ],
  );
  Widget _monthAction(BuildContext context, {required bool previous}) {
    final l = AppLocalizations.of(context);
    final now = DateTime.now();
    final canMove = !previous || _month.isAfter(DateTime(now.year, now.month));
    return IconButton(
      tooltip: previous ? l.deadlinePreviousMonth : l.deadlineNextMonth,
      onPressed: canMove ? () => _move(previous ? -1 : 1) : null,
      icon: RotatedBox(
        quarterTurns: previous ? 0 : 2,
        child: SvgPicture.asset(
          previous
              ? 'assets/icons/reminder_left.svg'
              : 'assets/icons/reminder_right.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(
            AppColors.of(context).subtle,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _weekdays(BuildContext context) => Row(
    children: [
      for (var day = 0; day < DateTime.daysPerWeek; day++)
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Tokens.space8),
              child: Text(
                DateFormat.E(AppLocalizations.of(context).localeName)
                    .format(DateTime(2024, 1, 1 + day))
                    .substring(0, 1),
                style: DeadlineTokens.badge.copyWith(
                  color: AppColors.of(context).subtle,
                ),
              ),
            ),
          ),
        ),
    ],
  );
  List<Widget> _weeks(BuildContext context) {
    final offset = _month.weekday - DateTime.monday;
    final count = DateTime(_month.year, _month.month + 1, 0).day;
    final rows = ((offset + count) / DateTime.daysPerWeek).ceil();
    return [
      for (var row = 0; row < rows; row++)
        Row(
          children: [
            for (var column = 0; column < DateTime.daysPerWeek; column++)
              Expanded(
                child: _day(
                  context,
                  row * DateTime.daysPerWeek + column - offset + 1,
                  count,
                ),
              ),
          ],
        ),
    ];
  }

  Widget _day(BuildContext context, int number, int count) {
    if (number < 1 || number > count)
      return const SizedBox(height: Tokens.minTouchTarget);
    final date = DateTime(_month.year, _month.month, number);
    final selected = DeadlineSchedule.day(widget.selected) == date;
    final enabled = DeadlineSchedule.daysBetween(date, DateTime.now()) >= 0;
    return Semantics(
      selected: selected,
      label: DateFormat.yMMMMEEEEd(AppLocalizations.of(context).localeName)
          .format(date),
      child: TextButton(
        onPressed: enabled ? () => widget.onSelected(date) : null,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size.square(Tokens.minTouchTarget),
        ),
        child: _dayFace(context, number, selected, enabled),
      ),
    );
  }

  Widget _dayFace(
    BuildContext context,
    int number,
    bool selected,
    bool enabled,
  ) {
    final colors = AppColors.of(context);
    return Container(
      width: DeadlineTokens.stopDayWidth,
      constraints: const BoxConstraints(
        minHeight: DeadlineTokens.calendarSelection,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? colors.primary : colors.surface,
        borderRadius: BorderRadius.circular(Tokens.space12),
      ),
      child: Text(
        number.toString(),
        style: Tokens.label.copyWith(
          color: selected
              ? colors.onPrimary
              : enabled
              ? colors.text
              : colors.subtle,
        ),
      ),
    );
  }

  void _move(int months) =>
      setState(() => _month = DateTime(_month.year, _month.month + months));
}
