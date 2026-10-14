import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_notice.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../../today/logic/today_controller.dart';
import '../../logic/missed_controller.dart';

class MissedConfirmation extends ConsumerWidget {
  const MissedConfirmation({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(todayOverviewProvider);
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(MissedController.provider.notifier);
    return HbPageScaffold(
      topBar: HbPageHeader(onBack: controller.choose),
      content: [
        HbHeading(title: l10n.missedConfirmTitle),
        Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(Tokens.space20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Tokens.space12,
              children: [
                Text(
                  data.witnessName.isEmpty
                      ? l10n.missedPrivateTitle
                      : l10n.missedTo(data.witnessName),
                  style: Tokens.small.copyWith(
                    color: AppColors.of(context).muted,
                  ),
                ),
                Text(
                  data.witnessName.isEmpty
                      ? l10n.missedWithoutWitness
                      : l10n.contractMessageQuote(data.consequence),
                  style: Tokens.body,
                ),
              ],
            ),
          ),
        ),
        HbNotice(
          title: l10n.missedNewFinish(
            DateFormat.MMMMEEEEd(l10n.localeName).format(data.missedFinishDate),
          ),
          body: l10n.missedChapterNext,
          iconSize: Tokens.space20,
        ),
      ],
      actions: [
        HbButton(
          label: data.witnessName.isEmpty ? l10n.missedLetGo : l10n.missedSend,
          onPressed: controller.letGo,
        ),
        HbButton(
          label: l10n.missedKeep,
          variant: HbButtonVariant.secondary,
          onPressed: controller.choose,
        ),
      ],
      footnote: Text(
        l10n.dailyPreview,
        textAlign: TextAlign.center,
        style: Tokens.small.copyWith(color: AppColors.of(context).muted),
      ),
    );
  }
}
