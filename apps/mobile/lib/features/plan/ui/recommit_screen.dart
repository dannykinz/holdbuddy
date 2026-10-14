import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_hold_button.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../domain/plan_change_kind.dart';
import '../domain/plan_view.dart';
import '../logic/plan_change_controller.dart';
import '../logic/plan_controller.dart';
import 'widgets/recommit_summary.dart';

class RecommitScreen extends ConsumerStatefulWidget {
  const RecommitScreen({super.key});
  @override
  ConsumerState<RecommitScreen> createState() => _RecommitScreenState();
}

class _RecommitScreenState extends ConsumerState<RecommitScreen> {
  int _attempt = 0;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final change = ref.watch(PlanChangeController.provider);
    return HbPageScaffold(
      topBar: const HbPageHeader(),
      content: [
        HbHeading(
          title: switch (change.kind) {
            PlanChangeKind.rhythm => l.recommitRhythm,
            PlanChangeKind.scope => l.recommitScope,
            PlanChangeKind.target => l.recommitTarget,
            PlanChangeKind.other => l.recommitOther,
          },
        ),
        const RecommitSummary(),
      ],
      actions: [
        HbHoldButton(
          key: ValueKey(_attempt),
          label: l.recommitHold,
          holdingLabel: l.recommitHolding,
          enabled: change.isValid,
          onCommitted: () => _commit(context, ref),
        ),
      ],
      footnote: HbPreviewNote(
        text: ref.watch(planChangeFailureProvider)
            ? l.settingsSaveError
            : l.planPreviewDates,
      ),
    );
  }

  void _commit(BuildContext context, WidgetRef ref) {
    if (!ref.read(PlanChangeController.provider.notifier).commit()) {
      setState(() => _attempt++);
      return;
    }
    ref.read(PlanController.provider.notifier).show(PlanView.updated);
    context.goNamed(AppRoute.plan.name);
  }
}
