import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_action_row.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../domain/plan_change_kind.dart';
import '../logic/plan_change_controller.dart';

class RenegotiateScreen extends ConsumerWidget {
  const RenegotiateScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return HbPageScaffold(
      topBar: const HbPageHeader(),
      content: [
        HbHeading(title: l.changeHeading, description: l.changeDescription),
        ..._choices(context, ref),
      ],
      actions: [
        HbButton(
          label: l.archiveThisPlan,
          variant: HbButtonVariant.ghost,
          onPressed: () => context.pushNamed(AppRoute.archiveConfirm.name),
        ),
      ],
    );
  }

  List<Widget> _choices(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    return [
      for (final kind in PlanChangeKind.values)
        HbActionRow(
          title: _copy(l, kind).$1,
          subtitle: _copy(l, kind).$2,
          asset: 'assets/icons/' + _copy(l, kind).$3 + '.svg',
          color: kind == PlanChangeKind.rhythm
              ? c.orange
              : kind == PlanChangeKind.other
              ? c.purple
              : c.sky,
          fill: kind == PlanChangeKind.rhythm
              ? c.orangeSoft
              : kind == PlanChangeKind.other
              ? c.purpleSoft
              : c.skySoft,
          onPressed: () {
            ref.read(PlanChangeController.provider.notifier).begin(kind);
            unawaited(context.pushNamed<void>(_route(kind).name));
          },
        ),
    ];
  }

  (String, String, String) _copy(AppLocalizations l, PlanChangeKind kind) =>
      switch (kind) {
        PlanChangeKind.rhythm => (
          l.changeRhythm,
          l.changeRhythmBody,
          'daily_calendar',
        ),
        PlanChangeKind.scope => (
          l.changeScope,
          l.changeScopeBody,
          'daily_book',
        ),
        PlanChangeKind.target => (
          l.changeTarget,
          l.changeTargetBody,
          'daily_clock',
        ),
        PlanChangeKind.other => (l.changeOther, l.changeOtherBody, 'daily_pen'),
      };
  AppRoute _route(PlanChangeKind kind) => switch (kind) {
    PlanChangeKind.rhythm => AppRoute.adjustRhythm,
    PlanChangeKind.scope => AppRoute.adjustScope,
    PlanChangeKind.target => AppRoute.adjustTargetDate,
    PlanChangeKind.other => AppRoute.adjustOther,
  };
}
