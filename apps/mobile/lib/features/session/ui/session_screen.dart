import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/router/navigation_error.dart';
import '../../focus/domain/study_mode.dart';
import '../../focus/logic/focus_controller.dart';
import '../../material/domain/material_kind.dart';
import '../../material/logic/material_controller.dart';
import '../../plan/logic/current_chapter.dart';
import '../../today/domain/today_view.dart';
import '../../today/logic/today_controller.dart';
import '../domain/session_stage.dart';
import '../logic/session_controller.dart';
import 'widgets/session_leave.dart';
import 'widgets/session_paused.dart';
import 'widgets/session_receipt.dart';
import 'widgets/session_running.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key, this.receipt = false, this.chapterNumber});
  final int? chapterNumber;
  final bool receipt;
  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = ref.read(SessionController.provider.notifier);
      if (widget.receipt) {
        controller.end();
        return;
      }
      final wasActive = controller.hasUnfinishedSession;
      if (!wasActive && ref.read(chapterProvider(widget.chapterNumber)) == null)
        return;
      controller.begin(
        first: ref.read(TodayController.provider) == TodayView.first,
        chapterNumber: widget.chapterNumber,
      );
      if (!wasActive) _openStudyMaterial();
    });
  }

  void _openStudyMaterial() {
    if (ref.read(FocusController.provider).mode != StudyMode.study) return;
    final material = ref
        .read(planMaterialsProvider)
        .where(
          (item) =>
              item.kind == MaterialKind.pdf || item.kind == MaterialKind.audio,
        )
        .firstOrNull;
    if (material == null) return;
    unawaited(
      context.pushNamed<void>(
        material.kind == MaterialKind.pdf
            ? AppRoute.readerPdf.name
            : AppRoute.playerAudio.name,
        extra: material.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unfinished = ref
        .read(SessionController.provider.notifier)
        .hasUnfinishedSession;
    if (!unfinished && ref.watch(chapterProvider(widget.chapterNumber)) == null)
      return const NavigationError();
    ref.listen(SessionController.provider.select((value) => value.stage), (
      previous,
      next,
    ) {
      final receipt =
          next == SessionStage.receipt || next == SessionStage.firstSaved;
      if (receipt && !widget.receipt)
        context.goNamed(AppRoute.sessionSaved.name);
      if (next == SessionStage.running && widget.receipt)
        context.pushReplacementNamed(AppRoute.session.name);
    });
    final stage = ref.watch(
      SessionController.provider.select((value) => value.stage),
    );
    final body = switch (stage) {
      SessionStage.running => const SessionRunning(),
      SessionStage.paused => const SessionPaused(),
      SessionStage.leave => const SessionLeave(),
      _ => const SessionReceipt(),
    };
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final controller = ref.read(SessionController.provider.notifier);
        if (stage == SessionStage.leave) {
          controller.keepStudying();
          return;
        }
        if (widget.receipt) {
          controller.resume();
          return;
        }
        controller.leave();
      },
      child: body,
    );
  }
}
