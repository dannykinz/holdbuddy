import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../../core/widgets/hb_notice.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../../plan/logic/current_chapter.dart';
import '../../../today/logic/today_controller.dart';
import '../../domain/missed_view.dart';
import '../../logic/missed_controller.dart';
import 'session_next.dart';

class MissedResult extends ConsumerWidget {
  const MissedResult({super.key, required this.view});
  final MissedView view;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(todayOverviewProvider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final moved = view == MissedView.moved;
    final sent = view == MissedView.sent;
    return HbPageScaffold(
      topBar: HbPageHeader(
        onBack: ref.read(MissedController.provider.notifier).choose,
      ),
      content: [
        _hero(context),
        _heading(context, ref),
        if (!sent)
          SessionNext(
            date: moved ? data.movedDate : data.nextDate,
            chapter: ref.watch(currentChapterProvider),
          ),
        if (moved)
          HbNotice(
            title: l10n.sessionStillFinishing(
              DateFormat.MMMMd(l10n.localeName).format(data.finishDate),
            ),
            body: l10n.missedNoMessage,
            iconSize: Tokens.space20,
          )
        else
          Text(
            l10n.missedNewFinish(
              DateFormat.MMMMd(l10n.localeName).format(data.missedFinishDate),
            ),
            style: Tokens.strong,
          ),
      ],
      actions: [
        HbButton(
          label: l10n.dailyBackToday,
          onPressed: () {
            ref.read(MissedController.provider.notifier).choose();
            context.goNamed(
              moved ? AppRoute.today.name : AppRoute.welcomeBack.name,
            );
          },
        ),
      ],
      footnote: moved
          ? null
          : Text(
              l10n.dailyPreview,
              textAlign: TextAlign.center,
              style: Tokens.small.copyWith(color: colors.muted),
            ),
    );
  }

  Widget _hero(BuildContext context) {
    final colors = AppColors.of(context);
    final moved = view == MissedView.moved;
    final sent = view == MissedView.sent;
    return HbHeroTile(
      asset: sent
          ? 'assets/icons/daily_message.svg'
          : moved
          ? 'assets/icons/daily_calendar_hero.svg'
          : 'assets/icons/daily_offline_hero.svg',
      color: sent ? colors.pink : colors.orange,
      fill: sent ? colors.pinkSoft : colors.orangeSoft,
      size: AuthTokens.heroSize,
      radius: AuthTokens.heroRadius,
    );
  }

  Widget _heading(BuildContext context, WidgetRef ref) {
    final data = ref.watch(todayOverviewProvider);
    final l10n = AppLocalizations.of(context);
    final moved = view == MissedView.moved;
    final sent = view == MissedView.sent;
    if (!moved && data.witnessName.isEmpty)
      return HbHeading(
        title: l10n.missedPrivateTitle,
        description: l10n.missedWithoutWitness,
      );
    return HbHeading(
      title: moved
          ? l10n.missedMovedTitle
          : sent
          ? l10n.missedSentTitle(data.witnessName)
          : l10n.missedQueuedTitle,
      description: moved
          ? l10n.missedMovedBody
          : sent
          ? l10n.missedSentBody
          : l10n.missedQueuedBody(data.witnessName),
    );
  }
}
