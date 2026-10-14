import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/router/navigation_error.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../../core/widgets/hb_notice.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../../today/logic/today_controller.dart';
import '../../logic/session_controller.dart';
import '../../logic/session_receipt_providers.dart';
import 'session_next.dart';

class SessionFirstReceipt extends ConsumerWidget {
  const SessionFirstReceipt({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(sessionPlanProvider);
    if (plan == null) return const NavigationError();
    final state = ref.watch(SessionController.provider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.sessionSaved),
      topBar: HbPageHeader(
        title: state.planName,
        onBack: ref.read(SessionController.provider.notifier).resume,
      ),
      content: [
        HbHeroTile(
          asset: 'assets/icons/daily_first_check.svg',
          color: colors.green,
          fill: colors.greenSoft,
          size: AuthTokens.heroSize,
          radius: AuthTokens.heroRadius,
        ),
        HbHeading(
          title: l10n.sessionFirstSavedTitle,
          description: l10n.sessionFirstCovered,
        ),
        SessionNext(chapter: ref.watch(sessionNextChapterProvider)),
        HbNotice(
          title: l10n.sessionUnderway,
          body: l10n.sessionStillFinishing(
            DateFormat.MMMMd(l10n.localeName).format(plan.targetDate),
          ),
          iconSize: Tokens.space20,
        ),
      ],
      actions: [
        HbButton(
          label: l10n.sessionBackPlan,
          onPressed: () {
            ref.read(SessionController.provider.notifier).save();
            ref
                .read(TodayController.provider.notifier)
                .sessionSaved(units: state.units, first: true);
            context.goNamed(AppRoute.today.name);
          },
        ),
      ],
    );
  }
}
