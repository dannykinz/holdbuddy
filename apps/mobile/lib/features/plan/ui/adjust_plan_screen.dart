import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../domain/plan_change_kind.dart';
import '../logic/plan_change_controller.dart';
import 'widgets/adjust_other_fields.dart';
import 'widgets/adjust_rhythm_fields.dart';
import 'widgets/adjust_scope_fields.dart';
import 'widgets/adjust_target_field.dart';
import 'widgets/change_projection.dart';

class AdjustPlanScreen extends ConsumerStatefulWidget {
  const AdjustPlanScreen({super.key, required this.kind, this.nested = false});
  final PlanChangeKind kind;
  final bool nested;
  @override
  ConsumerState<AdjustPlanScreen> createState() => _AdjustPlanScreenState();
}

class _AdjustPlanScreenState extends ConsumerState<AdjustPlanScreen> {
  PlanChangeKind get kind => widget.kind;
  bool get nested => widget.nested;
  bool _ready = true;
  @override
  void initState() {
    super.initState();
    if (nested || ref.read(PlanChangeController.provider).kind == kind) return;
    _ready = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(PlanChangeController.provider.notifier).begin(kind);
      setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (!_ready)
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(semanticsLabel: l.loading),
        ),
      );
    final change = ref.watch(PlanChangeController.provider);
    final (title, heading, body) = _copy(l, change.plan.unitsDone);
    return HbPageScaffold(
      topBar: HbPageHeader(title: title),
      content: [
        HbHeading(title: heading, description: body),
        switch (kind) {
          PlanChangeKind.rhythm => const AdjustRhythmFields(),
          PlanChangeKind.scope => const AdjustScopeFields(),
          PlanChangeKind.target => const AdjustTargetField(),
          PlanChangeKind.other => const AdjustOtherFields(),
        },
        if (kind != PlanChangeKind.other) ChangeProjection(kind: kind),
      ],
      actions: [_review(context, change.isValid)],
      footnote: HbPreviewNote(text: l.planPreviewDates),
    );
  }

  (String, String, String?) _copy(AppLocalizations l, int done) =>
      switch (kind) {
        PlanChangeKind.rhythm => (
          l.adjustRhythmTitle,
          l.adjustRhythmHeading,
          l.adjustRhythmBody,
        ),
        PlanChangeKind.scope => (
          l.adjustScopeTitle,
          l.adjustScopeHeading,
          l.adjustScopeBody(done),
        ),
        PlanChangeKind.target => (
          l.adjustTargetTitle,
          l.adjustTargetHeading,
          null,
        ),
        PlanChangeKind.other => (
          l.adjustOtherTitle,
          l.adjustOtherHeading,
          l.adjustOtherBody,
        ),
      };

  Widget _review(BuildContext context, bool valid) {
    final l = AppLocalizations.of(context);
    return HbButton(
      label: nested ? l.saveChanges : l.reviewChanges,
      onPressed: valid
          ? () {
              if (nested) {
                Navigator.pop(context);
                return;
              }
              unawaited(context.pushNamed<void>(AppRoute.recommit.name));
            }
          : null,
    );
  }
}
