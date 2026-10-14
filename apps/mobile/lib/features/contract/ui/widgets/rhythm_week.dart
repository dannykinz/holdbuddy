import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_weekday_chip.dart';
import '../../logic/contract_controller.dart';

class RhythmWeek extends ConsumerWidget {
  const RhythmWeek({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(ContractController.provider).days;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Tokens.space8,
      children: [
        Text(
          AppLocalizations.of(context).contractStudyDays,
          style: AuthTokens.fieldLabel.copyWith(
            color: AppColors.of(context).muted,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: WidgetTokens.lineWidth,
            children: [
              for (var day = 1; day <= 7; day++) _day(ref, day, days, locale),
            ],
          ),
        ),
      ],
    );
  }

  Widget _day(WidgetRef ref, int day, List<int> days, String locale) {
    final start = ref.read(ContractController.provider).startDate;
    final date = start.add(Duration(days: day - start.weekday));
    final fullName = DateFormat.EEEE(locale).format(date);
    return Semantics(
      label: fullName,
      child: HbWeekdayChip(
        label: DateFormat.E(locale).format(date).substring(0, 1),
        selected: days.contains(day),
        onSelected: () =>
            ref.read(ContractController.provider.notifier).toggleDay(day),
      ),
    );
  }
}
