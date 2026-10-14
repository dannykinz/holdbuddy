import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../core/widgets/hb_day_chip.dart';
import '../../../../core/widgets/hb_day_status.dart';
import '../../domain/calendar_day.dart';
import '../../domain/calendar_status.dart';
import '../../domain/today_view.dart';
import '../../logic/today_controller.dart';

class TodayWeek extends ConsumerWidget {
  const TodayWeek({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final day in ref.watch(todayCalendarProvider))
          _day(context, ref, day),
      ],
    ),
  );

  Widget _day(BuildContext context, WidgetRef ref, CalendarDay day) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return HbDayChip(
      weekday: DateFormat.E(locale).format(day.date).toUpperCase(),
      day: day.date.day.toString(),
      dateLabel: DateFormat.yMMMMEEEEd(locale).format(day.date),
      status: HbDayStatus.values.byName(day.status.name),
      onPressed: () {
        if (day.status == CalendarStatus.missed) {
          unawaited(context.pushNamed<void>(AppRoute.missedSession.name));
          return;
        }
        ref
            .read(TodayController.provider.notifier)
            .show(
              day.status == CalendarStatus.rest
                  ? TodayView.rest
                  : TodayView.ready,
            );
      },
    );
  }
}
