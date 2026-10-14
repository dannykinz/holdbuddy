import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/progress_snapshot.dart';
import '../../logic/progress_controller.dart';
import 'progress_totals.dart';

class ProgressSummary extends ConsumerWidget {
  const ProgressSummary({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(progressSnapshotProvider);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        _duration(context, data),
        Wrap(
          spacing: Tokens.space20,
          runSpacing: Tokens.space8,
          children: [
            _stat(context, 'book_small', l10n.progressSessions(data.sessions)),
            _stat(context, 'pen_small', l10n.previewNotes(data.notes)),
            _stat(
              context,
              'refresh_small',
              l10n.progressComebacks(data.comebacks),
            ),
          ],
        ),
        const ProgressTotals(),
      ],
    );
  }

  Widget _stat(BuildContext context, String icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: Tokens.space8,
    children: [
      SvgPicture.asset(
        'assets/icons/progress_$icon.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(
          AppColors.of(context).accent,
          BlendMode.srcIn,
        ),
      ),
      Text(label, style: Tokens.label),
    ],
  );

  Widget _duration(BuildContext context, ProgressSnapshot data) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: Tokens.space8,
      children: [
        Text(
          l10n.progressDuration(data.minutes ~/ 60, data.minutes % 60),
          style: ProgressTokens.summary,
        ),
        Text(
          l10n.progressTarget(
            data.targetMinutes ~/ 60,
            data.targetMinutes % 60,
          ),
          style: Tokens.strong.copyWith(color: AppColors.of(context).subtle),
        ),
      ],
    );
  }
}
