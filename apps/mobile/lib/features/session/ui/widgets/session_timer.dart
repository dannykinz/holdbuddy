import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../logic/session_controller.dart';

class SessionTimer extends ConsumerWidget {
  const SessionTimer({super.key, this.showCaption = true});
  final bool showCaption;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(SessionController.provider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final time =
        '${(state.remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(state.remainingSeconds % 60).toString().padLeft(2, '0')}';
    return Column(
      spacing: Tokens.space8,
      children: [
        if (showCaption)
          Text(
            l10n.sessionTimeRemaining,
            style: Tokens.small.copyWith(color: colors.muted),
          ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(time, style: Tokens.timer.copyWith(color: colors.text)),
        ),
        if (showCaption)
          Text(
            l10n.sessionElapsed(
              state.elapsedSeconds ~/ 60,
              (state.elapsedSeconds % 60).toString().padLeft(2, '0'),
            ),
            style: Tokens.small.copyWith(color: colors.muted),
          ),
      ],
    );
  }
}
