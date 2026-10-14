import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../../today/logic/today_controller.dart';
import '../../logic/missed_controller.dart';

class MissedChoices extends ConsumerWidget {
  const MissedChoices({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(todayOverviewProvider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final controller = ref.read(MissedController.provider.notifier);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.missedSession),
      topBar: const HbPageHeader(),
      content: [
        HbHeroTile(
          asset: 'assets/icons/daily_clock_hero.svg',
          color: colors.sky,
          fill: colors.skySoft,
        ),
        HbHeading(title: l10n.missedTitle, description: l10n.missedBody),
        HbActionRow(
          title: data.chapterName,
          subtitle: l10n.missedSessionSummary(data.planName),
          asset: 'assets/icons/daily_book.svg',
          color: colors.sky,
          fill: colors.skySoft,
          trailing: const SizedBox.shrink(),
        ),
        _message(context, ref),
      ],
      actions: [
        HbButton(
          label: l10n.missedDoNow,
          onPressed: () => context.pushNamed(AppRoute.sessionChooseMode.name),
        ),
        HbButton(
          label: l10n.missedMove,
          variant: HbButtonVariant.secondary,
          onPressed: controller.move,
        ),
        HbButton(
          label: l10n.missedLetGo,
          variant: HbButtonVariant.ghost,
          onPressed: controller.confirm,
        ),
      ],
    );
  }

  Widget _message(BuildContext context, WidgetRef ref) {
    final data = ref.watch(todayOverviewProvider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final message = data.witnessName.isEmpty
        ? l10n.missedWithoutWitness
        : l10n.contractMessageQuote(data.consequence);
    return Container(
      padding: const EdgeInsets.all(Tokens.space20),
      decoration: BoxDecoration(
        color: colors.soft,
        borderRadius: BorderRadius.circular(Tokens.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Tokens.space12,
        children: [
          Text(
            data.witnessName.isEmpty
                ? l10n.missedPrivateTitle
                : l10n.missedMessageLabel(data.witnessName),
            style: Tokens.label.copyWith(color: colors.muted),
          ),
          Text(message, style: Tokens.body),
        ],
      ),
    );
  }
}
