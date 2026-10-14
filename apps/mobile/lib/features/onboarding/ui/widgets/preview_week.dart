import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/fakes/fake_onboarding_data.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_day_chip.dart';
import '../../../../core/widgets/hb_day_status.dart';

class PreviewWeek extends StatelessWidget {
  const PreviewWeek({super.key});
  static const _statuses = [
    HbDayStatus.done,
    HbDayStatus.done,
    HbDayStatus.missed,
    HbDayStatus.rest,
    HbDayStatus.today,
    HbDayStatus.planned,
    HbDayStatus.rest,
  ];

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context).localeName;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var index = 0; index < _statuses.length; index++)
          Expanded(
            child: FittedBox(fit: BoxFit.scaleDown, child: _day(index, locale)),
          ),
      ],
    );
  }

  Widget _day(int index, String locale) {
    final date = FakeOnboardingData.weekStart.add(Duration(days: index));
    return SizedBox(
      width: WidgetTokens.dayWidth,
      height: WidgetTokens.dayHeight,
      child: OverflowBox(
        maxWidth: Tokens.minTouchTarget,
        child: HbDayChip(
          weekday: DateFormat.E(locale).format(date).toUpperCase(),
          day: DateFormat.d(locale).format(date),
          dateLabel: DateFormat.yMMMMd(locale).format(date),
          status: _statuses[index],
        ),
      ),
    );
  }
}
