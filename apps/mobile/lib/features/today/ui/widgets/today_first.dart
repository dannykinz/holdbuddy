import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_notice.dart';
import '../../../contract/logic/contract_controller.dart';
import '../../../plan/logic/plan_controller.dart';
import 'first_session_card.dart';

class TodayFirst extends ConsumerWidget {
  const TodayFirst({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(ContractController.provider);
    final plan = ref.watch(chosenPlanProvider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        HbHeading(
          title: l10n.todayFirstBefore,
          accent: l10n.todayFirstAccent,
          after: l10n.headlinePeriod,
        ),
        const FirstSessionCard(),
        HbActionRow(
          title: DateFormat.MMMMd(l10n.localeName).format(plan.targetDate),
          subtitle: l10n.todayFinishUnits(plan.totalUnits),
          asset: 'assets/icons/daily_calendar.svg',
          color: colors.orange,
          fill: colors.orangeSoft,
          onPressed: () => context.goNamed(AppRoute.plan.name),
        ),
        if (plan.title == draft.title && !draft.withoutWitness)
          HbNotice(
            title: l10n.todayInvitePreview,
            body: l10n.todayInviteBody(draft.witnessName),
            iconSize: Tokens.space20,
          ),
      ],
    );
  }
}
