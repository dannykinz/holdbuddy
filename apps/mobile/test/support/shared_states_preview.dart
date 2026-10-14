import 'package:flutter/material.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/hb_button.dart';
import 'package:holdbuddy/core/widgets/hb_button_variant.dart';
import 'package:holdbuddy/core/widgets/hb_category.dart';
import 'package:holdbuddy/core/widgets/hb_empty_state.dart';
import 'package:holdbuddy/core/widgets/hb_error_state.dart';
import 'package:holdbuddy/core/widgets/hb_sheet.dart';

class SharedStatesPreview extends StatelessWidget {
  const SharedStatesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space24,
      children: [
        HbEmptyState(
          title: strings.emptyNotesHeading,
          description: strings.emptyNotesDescription,
          detail: strings.emptyNotesPrivacy,
          asset: 'assets/icons/empty_note.svg',
          category: HbCategory.purple,
          action: HbButton(
            label: strings.navigationReturn,
            onPressed: () {},
            variant: HbButtonVariant.secondary,
          ),
        ),
        SizedBox(
          height: 400,
          child: HbErrorState(
            error: StateError('Preview fixture'),
            onRetry: () {},
          ),
        ),
        HbSheet(title: strings.create, child: Text(strings.emptyNotesPrivacy)),
      ],
    );
  }
}
