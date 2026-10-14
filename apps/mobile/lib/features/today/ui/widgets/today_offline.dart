import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_notice.dart';
import '../../../plan/logic/plan_controller.dart';
import '../../logic/today_controller.dart';

class TodayOffline extends ConsumerWidget {
  const TodayOffline({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(todayOverviewProvider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        HbNotice(
          title: l10n.todayOfflineTitle,
          body: l10n.todayOfflineBody,
          asset: 'assets/icons/daily_offline_info.svg',
        ),
        HbHeading(
          title: l10n.todayNextBefore,
          accent: l10n.todayNextAccent,
          after: l10n.todayNextAfter,
        ),
        HbActionRow(
          title: data.chapterName,
          subtitle: l10n.todayOfflineSchedule(
            TimeOfDay.fromDateTime(data.nextDate).format(context),
            ref.watch(chosenPlanProvider).contract.duration.inMinutes,
          ),
          asset: 'assets/icons/daily_book.svg',
          color: colors.sky,
          fill: colors.skySoft,
          onPressed: () => context.pushNamed(AppRoute.chapter.name),
        ),
        HbButton(
          label: l10n.startSession,
          onPressed: () => context.pushNamed(AppRoute.sessionChooseMode.name),
        ),
        Text(
          l10n.todayOfflineMaterial,
          style: Tokens.small.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
