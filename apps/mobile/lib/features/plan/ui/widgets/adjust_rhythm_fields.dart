import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_field.dart';
import '../../../../core/widgets/hb_weekday_chip.dart';
import '../../logic/plan_change_controller.dart';

class AdjustRhythmFields extends ConsumerStatefulWidget {
  const AdjustRhythmFields({super.key});
  @override
  ConsumerState<AdjustRhythmFields> createState() => _AdjustRhythmFieldsState();
}

class _AdjustRhythmFieldsState extends ConsumerState<AdjustRhythmFields> {
  final _time = TextEditingController();
  late final _length = TextEditingController(
    text: ref
        .read(PlanChangeController.provider)
        .plan
        .contract
        .duration
        .inMinutes
        .toString(),
  );
  @override
  void dispose() {
    _time.dispose();
    _length.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contract = ref.watch(PlanChangeController.provider).plan.contract;
    final l = AppLocalizations.of(context);
    _time.text = TimeOfDay.fromDateTime(DateTime(2026).add(contract.time))
        .format(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        _week(context, contract.days),
        GestureDetector(
          onTap: () => _pickTime(contract.time),
          child: AbsorbPointer(
            child: HbField(label: l.rhythmStartTime, controller: _time),
          ),
        ),
        HbField(
          label: l.rhythmSessionLength,
          controller: _length,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: _duration,
          errorText: contract.duration.inMinutes > 0 ? null : l.adjustInvalid,
        ),
      ],
    );
  }

  Widget _week(BuildContext context, List<int> days) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      spacing: Tokens.navGap,
      children: [
        for (var day = 1; day <= 7; day++)
          HbWeekdayChip(
            label: DateFormat(
              'EEEEE',
              AppLocalizations.of(context).localeName,
            ).format(DateTime(2026, 10, 12 + day - 1)),
            selected: days.contains(day),
            onSelected: () =>
                ref.read(PlanChangeController.provider.notifier).toggleDay(day),
          ),
      ],
    ),
  );
  void _duration(String value) {
    final controller = ref.read(PlanChangeController.provider.notifier);
    final change = ref.read(PlanChangeController.provider);
    controller.update(
      change.copyWith(
        plan: change.plan.copyWith(
          contract: change.plan.contract.copyWith(
            duration: Duration(minutes: int.tryParse(value) ?? 0),
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime(Duration time) async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: time.inHours, minute: time.inMinutes % 60),
    );
    if (!mounted || result == null) return;
    final change = ref.read(PlanChangeController.provider);
    ref
        .read(PlanChangeController.provider.notifier)
        .update(
          change.copyWith(
            plan: change.plan.copyWith(
              contract: change.plan.contract.copyWith(
                time: Duration(hours: result.hour, minutes: result.minute),
              ),
            ),
          ),
        );
  }
}
