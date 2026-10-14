import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../focus/logic/focus_controller.dart';
import '../../../session/logic/session_controller.dart';
import '../material_copy.dart';

class MaterialSessionPill extends ConsumerWidget {
  const MaterialSessionPill({super.key, this.focusLabel = false});
  final bool focusLabel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(SessionController.provider);
    if (!ref.read(SessionController.provider.notifier).isActive)
      return const SizedBox.shrink();
    final focus = ref.watch(FocusController.provider).active;
    final time = MaterialCopy.time(session.remainingSeconds);
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Tokens.space12,
        vertical: Tokens.space8,
      ),
      decoration: ShapeDecoration(
        color: colors.greenSoft,
        shape: Tokens.chipShape,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: MaterialTokens.highlightInset,
        children: [
          if (focus)
            SvgPicture.asset(
              'assets/icons/reader_moon.svg',
              excludeFromSemantics: true,
              colorFilter: ColorFilter.mode(colors.green, BlendMode.srcIn),
            ),
          Flexible(
            child: Text(
              focusLabel && focus
                  ? AppLocalizations.of(context).materialSessionTime(time)
                  : time,
              style: MaterialTokens.compact.copyWith(color: colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
