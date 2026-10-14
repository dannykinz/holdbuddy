import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_notice.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_step_header.dart';
import '../logic/contract_controller.dart';
import 'widgets/rhythm_fields.dart';
import 'widgets/rhythm_week.dart';

class RhythmScreen extends ConsumerWidget {
  const RhythmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(ContractController.provider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final finish = DateFormat(
      'd MMMM',
      locale,
    ).format(ref.watch(contractFinishProvider));
    final start = DateFormat('EEEE, d MMM', locale).format(draft.startDate);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.rhythm),
      topBar: const HbStepHeader(step: 2),
      content: [
        HbHeading(
          title: l10n.contractRhythmTitle,
          description: l10n.contractRhythmBody,
        ),
        const RhythmWeek(),
        const RhythmFields(),
        if (draft.rhythmValid)
          HbNotice(
            title: l10n.contractFinishOn(finish),
            body: l10n.contractSchedulePreview(draft.days.length, start),
            iconSize: Tokens.space20,
          ),
      ],
      actions: [
        HbButton(
          label: l10n.contractChooseConsequence,
          onPressed: draft.rhythmValid
              ? () => context.pushNamed(AppRoute.consequence.name)
              : null,
        ),
      ],
    );
  }
}
