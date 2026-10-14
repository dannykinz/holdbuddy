import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../plan/logic/current_chapter.dart';
import '../../../session/ui/widgets/session_next.dart';

class TodayRest extends ConsumerWidget {
  const TodayRest({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        HbHeroTile(
          asset: 'assets/icons/daily_sun.svg',
          color: colors.orange,
          fill: colors.orangeSoft,
          size: AuthTokens.heroSize,
          radius: AuthTokens.heroRadius,
        ),
        HbHeading(title: l10n.todayRestTitle),
        SessionNext(chapter: ref.watch(currentChapterProvider)),
        Text(
          l10n.todayRestBody,
          style: Tokens.body.copyWith(color: colors.muted),
        ),
        HbButton(
          label: l10n.todaySeePlan,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.plan.name),
        ),
      ],
    );
  }
}
