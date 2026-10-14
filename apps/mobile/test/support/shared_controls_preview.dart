import 'package:flutter/material.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/fakes/fake_seed_data.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/hb_button.dart';
import 'package:holdbuddy/core/widgets/hb_button_variant.dart';
import 'package:holdbuddy/core/widgets/hb_code_input.dart';
import 'package:holdbuddy/core/widgets/hb_field.dart';

class SharedControlsPreview extends StatefulWidget {
  const SharedControlsPreview({super.key});
  @override
  State<SharedControlsPreview> createState() => _SharedControlsPreviewState();
}

class _SharedControlsPreviewState extends State<SharedControlsPreview> {
  final _plan = TextEditingController(
    text: FakeSeedData(DateTime(2026, 10, 12)).plan.title,
  );
  final _code = TextEditingController(text: '48216');

  @override
  void dispose() {
    _plan.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        HbButton(label: strings.continueAction, onPressed: () {}),
        HbButton(
          label: strings.continueAction,
          onPressed: () {},
          variant: HbButtonVariant.secondary,
        ),
        HbButton(
          label: strings.continueAction,
          onPressed: () {},
          variant: HbButtonVariant.ghost,
        ),
        HbButton(label: strings.continueAction, onPressed: null),
        HbButton(
          label: strings.continueAction,
          onPressed: () {},
          loading: true,
        ),
        HbButton(
          label: strings.continueAction,
          onPressed: () {},
          google: true,
          variant: HbButtonVariant.secondary,
        ),
        HbButton(
          label: strings.continueAction,
          onPressed: () {},
          destructive: true,
        ),
        HbField(label: strings.planNameLabel, controller: _plan),
        HbField(
          label: strings.planNameLabel,
          controller: _plan,
          errorText: strings.validationRequired,
        ),
        HbField(
          label: strings.planNameLabel,
          controller: _plan,
          enabled: false,
        ),
        HbCodeInput(label: strings.verificationCode, controller: _code),
      ],
    );
  }
}
