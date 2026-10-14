import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_action_row.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../profile/logic/learner_providers.dart';
import '../../today/logic/today_controller.dart';
import 'widgets/return_finish_card.dart';

class WelcomeBackScreen extends ConsumerWidget {
  const WelcomeBackScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(todayOverviewProvider);
    final learner = ref.watch(learnerProvider).value;
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.welcomeBack),
      topBar: const HbPageHeader(),
      content: [
        HbHeroTile(
          asset: 'assets/icons/daily_refresh_hero.svg',
          color: colors.green,
          fill: colors.greenSoft,
        ),
        HbHeading(
          title: l10n.dailyWelcomeBefore,
          accent: learner?.displayName ?? '',
          after: l10n.headlinePeriod,
          description: l10n.dailyWelcomeBody(data.missedSessions),
        ),
        ReturnFinishCard(
          date: data.returnFinishDate,
          previous: data.finishDate,
        ),
        Text(
          l10n.dailyRemaining(data.totalUnits - data.unitsDone),
          style: Tokens.strong,
        ),
        HbActionRow(
          title: l10n.dailyPickUp(data.unitsDone + 1),
          subtitle: data.chapterName,
          asset: 'assets/icons/daily_book.svg',
          color: colors.sky,
          fill: colors.skySoft,
          onPressed: () => context.pushNamed(AppRoute.chapter.name),
        ),
      ],
      actions: [
        HbButton(
          label: l10n.continueAction,
          onPressed: () => context.goNamed(AppRoute.today.name),
        ),
      ],
    );
  }
}
