import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/hb_button.dart';
import 'package:holdbuddy/core/widgets/hb_sheet.dart';

import '../../support/load_inter_font.dart';
import '../../support/pump_shared_widget.dart';

void main() {
  setUpAll(loadInterFont);
  for (final theme in [AppTheme.light, AppTheme.dark]) _sheetTest(theme);
}

void _sheetTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} native modal sheet uses the scrim and returns its result',
    (tester) async {
      String? result;
      await pumpSharedWidget(
        tester,
        theme,
        (context) => _openSheet(context, (value) => result = value),
      );
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();
      expect(find.byType(HbSheet), findsOneWidget);
      final barrier = tester.widget<ModalBarrier>(
        find.byType(ModalBarrier).last,
      );
      expect(
        barrier.color,
        Tokens.ink.withValues(alpha: WidgetTokens.sheetScrimOpacity),
      );
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(result, 'saved');
      expect(find.byType(HbSheet), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

Widget _openSheet(BuildContext context, ValueChanged<String?> onResult) =>
    HbButton(
      label: AppLocalizations.of(context).create,
      onPressed: () async {
        final result = await HbSheet.show<String>(
          context: context,
          title: AppLocalizations.of(context).create,
          child: HbButton(
            label: AppLocalizations.of(context).continueAction,
            onPressed: () => Navigator.of(context).pop('saved'),
          ),
        );
        onResult(result);
      },
    );
