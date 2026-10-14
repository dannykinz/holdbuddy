import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_field.dart';
import '../../logic/contract_controller.dart';

class RhythmFields extends ConsumerStatefulWidget {
  const RhythmFields({super.key});
  @override
  ConsumerState<RhythmFields> createState() => _RhythmFieldsState();
}

class _RhythmFieldsState extends ConsumerState<RhythmFields> {
  final _time = TextEditingController();
  late final _minutes = TextEditingController(
    text: ref.read(ContractController.provider).sessionMinutes.toString(),
  );
  late final _units = TextEditingController(
    text: ref.read(ContractController.provider).unitsPerSession.toString(),
  );

  @override
  void dispose() {
    _time.dispose();
    _minutes.dispose();
    _units.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(ContractController.provider);
    _time.text = TimeOfDay(
      hour: draft.startMinute ~/ 60,
      minute: draft.startMinute % 60,
    ).format(context);
    return Column(
      spacing: Tokens.space20,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: ContractTokens.unitsGap,
          children: [
            Expanded(child: _timeField()),
            Expanded(
              child: _number(l10n.contractSessionLength, _minutes, true),
            ),
          ],
        ),
        _number(l10n.contractUnitsPerSession(draft.unitName), _units, false),
      ],
    );
  }

  Widget _timeField() => GestureDetector(
    onTap: _chooseTime,
    child: AbsorbPointer(
      child: HbField(
        label: AppLocalizations.of(context).contractStartTime,
        labelStyle: AuthTokens.fieldLabel,
        controller: _time,
        readOnly: true,
      ),
    ),
  );

  Widget _number(
    String label,
    TextEditingController controller,
    bool duration,
  ) => HbField(
    label: label,
    labelStyle: AuthTokens.fieldLabel,
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    errorText: (int.tryParse(controller.text) ?? 0) > 0
        ? null
        : AppLocalizations.of(context).contractWholeNumberError,
    suffixIcon: duration
        ? Padding(
            padding: const EdgeInsets.all(Tokens.space8),
            child: Text(
              AppLocalizations.of(context).contractMinutesShort,
              style: Tokens.small,
            ),
          )
        : null,
    onChanged: (value) => _updateNumber(value, duration),
  );

  void _updateNumber(String value, bool duration) {
    final draft = ref.read(ContractController.provider);
    final count = int.tryParse(value) ?? 0;
    ref
        .read(ContractController.provider.notifier)
        .update(
          duration
              ? draft.copyWith(sessionMinutes: count)
              : draft.copyWith(unitsPerSession: count),
        );
  }

  Future<void> _chooseTime() async {
    final draft = ref.read(ContractController.provider);
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: draft.startMinute ~/ 60,
        minute: draft.startMinute % 60,
      ),
    );
    if (!mounted || time == null) return;
    ref
        .read(ContractController.provider.notifier)
        .update(draft.copyWith(startMinute: time.hour * 60 + time.minute));
  }
}
