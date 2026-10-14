import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../../core/widgets/hb_field.dart';
import '../../../../core/widgets/hb_sheet.dart';
import '../../domain/plan_change_kind.dart';
import '../../logic/plan_change_controller.dart';
import '../adjust_plan_screen.dart';
import 'change_message_sheet.dart';
import 'change_schedule_copy.dart';

class AdjustOtherFields extends ConsumerStatefulWidget {
  const AdjustOtherFields({super.key});
  @override
  ConsumerState<AdjustOtherFields> createState() => _AdjustOtherFieldsState();
}

class _AdjustOtherFieldsState extends ConsumerState<AdjustOtherFields> {
  late final _reason = TextEditingController(
    text: ref.read(PlanChangeController.provider).reason,
  );
  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final change = ref.watch(PlanChangeController.provider);
    return Column(
      spacing: Tokens.space20,
      children: [
        HbField(
          label: l.adjustChanged,
          controller: _reason,
          onChanged: (value) => ref
              .read(PlanChangeController.provider.notifier)
              .update(change.copyWith(reason: value.trim())),
        ),
        HbActionRow(
          title: l.adjustRhythmLabel,
          subtitle: ChangeScheduleCopy.text(context, change.plan.contract),
          asset: 'assets/icons/daily_calendar.svg',
          color: c.orange,
          fill: c.orangeSoft,
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => const AdjustPlanScreen(
                kind: PlanChangeKind.rhythm,
                nested: true,
              ),
            ),
          ),
        ),
        HbActionRow(
          title: l.adjustConsequence,
          subtitle: l.adjustConsequenceBody,
          asset: 'assets/icons/daily_message.svg',
          color: c.pink,
          fill: c.pinkSoft,
          onPressed: () => HbSheet.show<void>(
            context: context,
            title: l.adjustConsequence,
            child: const ChangeMessageSheet(),
          ),
        ),
        HbActionRow(
          title: l.adjustWitness,
          subtitle: l.recommitWitness,
          asset: 'assets/icons/privacy_eye.svg',
          color: c.sky,
          fill: c.skySoft,
          onPressed: () => context.pushNamed(AppRoute.witnessManage.name),
        ),
      ],
    );
  }
}
