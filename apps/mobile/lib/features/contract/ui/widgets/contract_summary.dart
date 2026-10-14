import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../logic/contract_controller.dart';

class ContractSummary extends ConsumerWidget {
  const ContractSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(Tokens.space20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.tintLine),
        borderRadius: BorderRadius.circular(Tokens.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Tokens.space16,
        children: _lines(context, ref),
      ),
    );
  }

  List<Widget> _lines(BuildContext context, WidgetRef ref) => [
    ..._scope(context, ref),
    const Divider(height: WidgetTokens.lineWidth),
    ..._rhythm(context, ref),
    const Divider(height: WidgetTokens.lineWidth),
    ..._witness(context, ref),
  ];
  List<Widget> _scope(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(ContractController.provider);
    final l10n = AppLocalizations.of(context);
    return [
      _text(context, draft.title, Tokens.title),
      _text(
        context,
        l10n.contractScopeSummary(
          draft.totalUnits,
          draft.unitName.toLowerCase(),
          draft.unitsPerSession,
        ),
        Tokens.body,
        muted: true,
      ),
    ];
  }

  List<Widget> _rhythm(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(ContractController.provider);
    final l10n = AppLocalizations.of(context);
    final days = draft.days
        .map(
          (day) => DateFormat.E(l10n.localeName).format(
            draft.startDate.add(Duration(days: day - draft.startDate.weekday)),
          ),
        )
        .join(', ');
    final time = TimeOfDay(
      hour: draft.startMinute ~/ 60,
      minute: draft.startMinute % 60,
    ).format(context);
    final date = DateFormat.MMMMd(l10n.localeName)
        .format(ref.watch(contractFinishProvider));
    return [
      _text(context, l10n.contractRhythmSummary(days, time), Tokens.strong),
      _text(
        context,
        l10n.contractFinishSummary(draft.sessionMinutes, date),
        Tokens.body,
        muted: true,
      ),
    ];
  }

  List<Widget> _witness(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(ContractController.provider);
    final l10n = AppLocalizations.of(context);
    return [
      _text(
        context,
        draft.withoutWitness
            ? l10n.contractNoWitness
            : l10n.contractWitnessSummary(draft.witnessName),
        Tokens.strong,
      ),
      _text(
        context,
        draft.withoutWitness
            ? l10n.contractNoWitnessBody
            : l10n.contractMessageQuote(draft.message),
        Tokens.body,
        muted: true,
      ),
    ];
  }

  Widget _text(
    BuildContext context,
    String text,
    TextStyle style, {
    bool muted = false,
  }) => Text(
    text,
    style: style.copyWith(
      color: muted ? AppColors.of(context).muted : AppColors.of(context).text,
    ),
  );
}
