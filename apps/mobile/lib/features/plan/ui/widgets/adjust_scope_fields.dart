import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_field.dart';
import '../../logic/plan_change_controller.dart';

class AdjustScopeFields extends ConsumerStatefulWidget {
  const AdjustScopeFields({super.key});
  @override
  ConsumerState<AdjustScopeFields> createState() => _AdjustScopeFieldsState();
}

class _AdjustScopeFieldsState extends ConsumerState<AdjustScopeFields> {
  late final _total = TextEditingController(
    text: ref.read(PlanChangeController.provider).plan.totalUnits.toString(),
  );
  late final _reason = TextEditingController(
    text: ref.read(PlanChangeController.provider).reason,
  );
  @override
  void dispose() {
    _total.dispose();
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final change = ref.watch(PlanChangeController.provider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        HbField(
          label: l.adjustTotal,
          controller: _total,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText:
              change.plan.totalUnits >= change.plan.unitsDone &&
                  change.plan.totalUnits > 0
              ? null
              : l.adjustInvalid,
          onChanged: (value) => ref
              .read(PlanChangeController.provider.notifier)
              .update(
                change.copyWith(
                  plan: change.plan.copyWith(
                    totalUnits: int.tryParse(value) ?? 0,
                  ),
                ),
              ),
        ),
        Text(
          l.adjustScopeMinimum(change.plan.unitsDone),
          style: Tokens.small.copyWith(color: AppColors.of(context).muted),
        ),
        HbField(
          label: l.adjustReason,
          controller: _reason,
          onChanged: (value) => ref
              .read(PlanChangeController.provider.notifier)
              .update(change.copyWith(reason: value.trim())),
        ),
      ],
    );
  }
}
