import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/deadline.dart';
import '../../domain/deadline_status.dart';
import '../../logic/deadline_controller.dart';
import 'deadline_card.dart';

class DeadlineSwipeRow extends ConsumerStatefulWidget {
  const DeadlineSwipeRow({
    super.key,
    required this.deadline,
    this.revealed = false,
  });
  final Deadline deadline;
  final bool revealed;
  @override
  ConsumerState<DeadlineSwipeRow> createState() => _DeadlineSwipeRowState();
}

class _DeadlineSwipeRowState extends ConsumerState<DeadlineSwipeRow> {
  late bool _open = widget.revealed;
  double _drag = 0;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: l.deadlineDone): () =>
            _change(DeadlineStatus.done),
        CustomSemanticsAction(label: l.deadlineArchive): () =>
            _change(DeadlineStatus.archived),
      },
      child: GestureDetector(
        onHorizontalDragStart: (_) => _drag = 0,
        onHorizontalDragUpdate: (details) => _drag += details.delta.dx,
        onHorizontalDragEnd: (_) {
          if (_drag.abs() > Tokens.space8) setState(() => _open = _drag < 0);
        },
        onLongPress: () => setState(() => _open = !_open),
        onTap: _open ? () => setState(() => _open = false) : null,
        child: _row(context),
      ),
    );
  }

  Widget _row(BuildContext context) => ClipRect(
    child: Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: ExcludeSemantics(
              excluding: !_open,
              child: IgnorePointer(ignoring: !_open, child: _actions(context)),
            ),
          ),
        ),
        AnimatedSlide(
          offset: _offset(context),
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : WidgetTokens.motionDuration,
          curve: Curves.easeOutCubic,
          child: IgnorePointer(
            ignoring: _open,
            child: DeadlineCard(deadline: widget.deadline),
          ),
        ),
      ],
    ),
  );
  Offset _offset(BuildContext context) => Offset(
    _open
        ? -DeadlineTokens.revealWidth /
              (MediaQuery.sizeOf(context).width - Tokens.screenMargin * 2)
        : 0,
    0,
  );
  Widget _actions(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: Tokens.space8,
    children: [
      _action(context, DeadlineStatus.done),
      _action(context, DeadlineStatus.archived),
    ],
  );
  Widget _action(BuildContext context, DeadlineStatus status) {
    final done = status == DeadlineStatus.done;
    final colors = AppColors.of(context);
    return SizedBox(
      width: DeadlineTokens.actionWidth,
      child: FilledButton(
        onPressed: ref.watch(DeadlineController.provider).isLoading
            ? null
            : () => _change(status),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.all(Tokens.space8),
          backgroundColor: done ? colors.green : colors.soft,
          foregroundColor: done ? colors.surface : colors.text,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DeadlineTokens.cardRadius),
          ),
        ),
        child: _actionContent(context, done),
      ),
    );
  }

  Future<void> _change(DeadlineStatus status) async {
    await ref
        .read(DeadlineController.provider.notifier)
        .changeStatus(widget.deadline, status);
  }

  Widget _actionContent(BuildContext context, bool done) {
    final colors = AppColors.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: DeadlineTokens.copyGap,
      children: [
        SvgPicture.asset(
          done
              ? 'assets/icons/reminder_swipe_check.svg'
              : 'assets/icons/reminder_archive.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(
            done ? colors.surface : colors.text,
            BlendMode.srcIn,
          ),
        ),
        Text(
          done
              ? AppLocalizations.of(context).deadlineDone
              : AppLocalizations.of(context).deadlineArchive,
          style: DeadlineTokens.badge,
        ),
      ],
    );
  }
}
