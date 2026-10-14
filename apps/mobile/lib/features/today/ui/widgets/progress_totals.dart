import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../logic/progress_controller.dart';

class ProgressTotals extends ConsumerWidget {
  const ProgressTotals({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(progressSnapshotProvider);
    final l10n = AppLocalizations.of(context);
    return Row(
      spacing: Tokens.space12,
      children: [
        Expanded(
          child: _card(
            context,
            'book',
            data.totalSessions.toString(),
            l10n.progressSessionsLabel,
            AppColors.of(context).skySoft,
          ),
        ),
        Expanded(
          child: _card(
            context,
            'clock',
            l10n.progressDuration(
              data.totalMinutes ~/ 60,
              data.totalMinutes % 60,
            ),
            l10n.progressStudied,
            AppColors.of(context).purpleSoft,
          ),
        ),
        Expanded(
          child: _card(
            context,
            'refresh',
            data.totalComebacks.toString(),
            l10n.progressComebacksLabel,
            AppColors.of(context).greenSoft,
          ),
        ),
      ],
    );
  }

  Widget _card(
    BuildContext context,
    String icon,
    String number,
    String label,
    Color fill,
  ) => Card.outlined(
    child: Padding(
      padding: const EdgeInsets.all(Tokens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Tokens.space8,
        children: [
          _icon(context, icon, fill),
          Text(number, style: Tokens.strong),
          Text(
            label,
            style: Tokens.meta.copyWith(color: AppColors.of(context).muted),
          ),
        ],
      ),
    ),
  );

  Widget _icon(BuildContext context, String icon, Color fill) => Container(
    padding: const EdgeInsets.all(Tokens.space8),
    decoration: BoxDecoration(shape: BoxShape.circle, color: fill),
    child: SvgPicture.asset(
      'assets/icons/progress_$icon.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(switch (icon) {
        'book' => AppColors.of(context).sky,
        'clock' => AppColors.of(context).purple,
        _ => AppColors.of(context).green,
      }, BlendMode.srcIn),
    ),
  );
}
