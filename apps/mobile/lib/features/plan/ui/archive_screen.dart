import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_notice.dart';
import '../../../core/widgets/hb_result_screen.dart';
import '../../today/domain/today_view.dart';
import '../../today/logic/today_controller.dart';
import '../logic/plan_change_controller.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return HbResultScreen(
      title: l.archiveHeading,
      body: l.archiveBody,
      details: [
        HbNotice(title: l.archiveNotice, body: l.archiveNoticeBody),
        if (ref.watch(planChangeFailureProvider)) Text(l.settingsSaveError),
      ],
      actions: [
        HbButton(label: l.archivePlan, onPressed: () => _archive(context, ref)),
        HbButton(
          label: l.archiveKeep,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.plan.name),
        ),
      ],
    );
  }

  void _archive(BuildContext context, WidgetRef ref) {
    if (!ref.read(PlanChangeController.provider.notifier).archive()) return;
    ref.read(TodayController.provider.notifier).show(TodayView.empty);
    context.goNamed(AppRoute.archiveSaved.name);
  }
}
