import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_field.dart';
import '../../logic/plan_change_controller.dart';

class ChangeMessageSheet extends ConsumerStatefulWidget {
  const ChangeMessageSheet({super.key});
  @override
  ConsumerState<ChangeMessageSheet> createState() => _ChangeMessageSheetState();
}

class _ChangeMessageSheetState extends ConsumerState<ChangeMessageSheet> {
  late final _message = TextEditingController(
    text: ref
        .read(PlanChangeController.provider)
        .plan
        .contract
        .consequenceMessage,
  );
  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        HbField(
          label: l.adjustMessage,
          controller: _message,
          maxLines: 3,
          onChanged: (_) => setState(() {}),
        ),
        HbButton(
          label: l.adjustSaveMessage,
          onPressed: _message.text.trim().isEmpty ? null : _save,
        ),
      ],
    );
  }

  void _save() {
    final change = ref.read(PlanChangeController.provider);
    ref
        .read(PlanChangeController.provider.notifier)
        .update(
          change.copyWith(
            plan: change.plan.copyWith(
              contract: change.plan.contract.copyWith(
                consequenceMessage: _message.text.trim(),
              ),
            ),
          ),
        );
    Navigator.pop(context);
  }
}
