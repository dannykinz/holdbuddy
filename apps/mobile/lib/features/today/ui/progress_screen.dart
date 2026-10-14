import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/logging/logger.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_segmented.dart';
import '../logic/progress_controller.dart';
import 'widgets/progress_chart.dart';
import 'widgets/progress_milestones.dart';
import 'widgets/progress_summary.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final period = ref.watch(ProgressController.provider);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.progress),
      topBar: HbPageHeader(
        title: l10n.progress,
        trailing: IconButton.filledTonal(
          tooltip: l10n.progressShare,
          onPressed: () => _copy(context, ref),
          icon: SvgPicture.asset(
            'assets/icons/progress_share.svg',
            excludeFromSemantics: true,
            colorFilter: ColorFilter.mode(
              AppColors.of(context).text,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      gap: Tokens.space24,
      content: [
        HbSegmented(
          labels: [l10n.week, l10n.month, l10n.allTime],
          selected: period.index,
          onSelected: ref.read(ProgressController.provider.notifier).select,
        ),
        const ProgressChart(),
        const ProgressSummary(),
        const ProgressMilestones(),
      ],
      actions: const [],
    );
  }

  Future<void> _copy(BuildContext context, WidgetRef ref) async {
    final data = ref.read(progressSnapshotProvider);
    final l10n = AppLocalizations.of(context);
    var message = l10n.progressCopied;
    try {
      await Clipboard.setData(
        ClipboardData(
          text: l10n.progressShareSummary(
            data.totalSessions,
            data.totalMinutes,
            data.totalComebacks,
          ),
        ),
      );
    } catch (error, stack) {
      logError(error, stack);
      message = l10n.progressCopyError;
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
