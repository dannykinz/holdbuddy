import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../plan/logic/current_chapter.dart';
import '../../../plan/logic/plan_controller.dart';

class FirstSessionCard extends ConsumerWidget {
  const FirstSessionCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(chosenPlanProvider);
    final chapter = ref.watch(currentChapterProvider);
    if (chapter == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusCard),
        side: BorderSide(color: colors.tintLine),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Tokens.space16,
          children: [
            HbHeroTile(
              asset: 'assets/icons/daily_first_book.svg',
              color: colors.sky,
              fill: colors.skySoft,
              size: Tokens.minTouchTarget,
              radius: Tokens.radiusIconTile,
            ),
            Text(
              l10n.todayChapterOf(chapter.number, plan.totalUnits),
              style: Tokens.small.copyWith(color: colors.muted),
            ),
            Text(chapter.name, style: Tokens.headline),
            Text(
              l10n.updatedChapterDate(
                MaterialLocalizations.of(context)
                    .formatMediumDate(chapter.date),
                TimeOfDay.fromDateTime(chapter.date).format(context),
                plan.contract.duration.inMinutes,
              ),
              style: Tokens.body.copyWith(color: colors.muted),
            ),
            HbButton(
              label: l10n.todayStartFirst,
              onPressed: () => context.pushNamed(
                AppRoute.sessionChooseMode.name,
                extra: chapter.number,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
