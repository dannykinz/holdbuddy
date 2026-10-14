import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_field.dart';
import '../../logic/plan_change_controller.dart';

class AdjustTargetField extends ConsumerStatefulWidget {
  const AdjustTargetField({super.key});
  @override
  ConsumerState<AdjustTargetField> createState() => _AdjustTargetFieldState();
}

class _AdjustTargetFieldState extends ConsumerState<AdjustTargetField> {
  final _date = TextEditingController();
  @override
  void dispose() {
    _date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(PlanChangeController.provider).plan;
    _date.text = DateFormat.yMMMMd(AppLocalizations.of(context).localeName)
        .format(plan.targetDate);
    return GestureDetector(
      onTap: _pick,
      child: AbsorbPointer(
        child: HbField(
          label: AppLocalizations.of(context).adjustDate,
          controller: _date,
        ),
      ),
    );
  }

  Future<void> _pick() async {
    final change = ref.read(PlanChangeController.provider);
    final date = await showDatePicker(
      context: context,
      initialDate: change.plan.targetDate,
      firstDate: change.plan.startDate,
      lastDate: DateTime(change.plan.startDate.year + 10),
    );
    if (!mounted || date == null) return;
    ref
        .read(PlanChangeController.provider.notifier)
        .update(change.copyWith(plan: change.plan.copyWith(targetDate: date)));
  }
}
