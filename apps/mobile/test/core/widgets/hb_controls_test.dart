import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/app_colors.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/hb_button.dart';
import 'package:holdbuddy/core/widgets/hb_code_input.dart';
import 'package:holdbuddy/core/widgets/hb_field.dart';

import '../../support/load_inter_font.dart';
import '../../support/pump_shared_widget.dart';

void main() {
  setUpAll(loadInterFont);
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    _buttonTest(theme);
    _loadingButtonTest(theme);
    _fieldTest(theme);
    _codeTest(theme);
  }
}

void _buttonTest(ThemeData theme) {
  testWidgets('${theme.brightness} button press collapses its edge', (
    tester,
  ) async {
    var presses = 0;
    await pumpSharedWidget(
      tester,
      theme,
      (context) => HbButton(
        label: AppLocalizations.of(context).continueAction,
        onPressed: () => presses++,
      ),
    );
    expect(
      tester.getSize(find.byType(FilledButton)).height,
      greaterThanOrEqualTo(Tokens.buttonHeight),
    );
    expect(_edge(tester), WidgetTokens.buttonEdge);
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(FilledButton)),
    );
    await tester.pump();
    expect(_edge(tester), WidgetTokens.pressedEdge);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(presses, 1);
    expect(_edge(tester), WidgetTokens.buttonEdge);
  });
}

double? _edge(WidgetTester tester) {
  final box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(HbButton),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  final decoration = box.decoration as BoxDecoration;
  return decoration.boxShadow?.first.offset.dy;
}

void _loadingButtonTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} loading and disabled buttons block repeated actions',
    (tester) async {
      var presses = 0;
      await pumpSharedWidget(
        tester,
        theme,
        (context) => _blockedButtons(context, () => presses++),
      );
      for (final element in find.byType(FilledButton).evaluate()) {
        expect((element.widget as FilledButton).onPressed, isNull);
      }
      await tester.tap(find.byType(FilledButton).first);
      expect(presses, 0);
      expect(find.bySemanticsLabel(RegExp('Continue')), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
}

void _fieldTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} field accepts editing, focus, validation and disabling',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final colors = theme.extension<AppColors>();
      await _pumpField(tester, theme, controller);
      await tester.enterText(find.byType(TextField), 'Learning Dart');
      expect(controller.text, 'Learning Dart');
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.decoration?.focusedBorder?.borderSide.color, colors?.accent);
      await _pumpField(tester, theme, controller, enabled: false);
      final disabled = tester.widget<TextField>(find.byType(TextField));
      expect(disabled.enabled, isFalse);
      expect(disabled.style?.color, colors?.subtle);
      expect(
        disabled.decoration?.errorBorder?.borderSide.color,
        colors?.accent,
      );
      expect(find.text('Enter a plan name.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

void _codeTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} code input sanitizes paste, limits digits and supports deletion',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? completed;
      await _pumpCode(tester, theme, controller, (code) => completed = code);
      await tester.enterText(find.byType(TextField), '48a216789');
      await tester.pump();
      expect(controller.text, '482167');
      expect(completed, '482167');
      expect(find.text('4'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '482');
      await tester.pump();
      expect(controller.text, '482');
      expect(find.text('7'), findsNothing);
      expect(
        tester.getSize(find.byType(HbCodeInput)).width,
        greaterThanOrEqualTo(Tokens.minTouchTarget),
      );
      expect(tester.takeException(), isNull);
    },
  );
}

Widget _blockedButtons(BuildContext context, VoidCallback onPressed) => Column(
  children: [
    HbButton(
      label: AppLocalizations.of(context).continueAction,
      onPressed: onPressed,
      loading: true,
    ),
    HbButton(
      label: AppLocalizations.of(context).continueAction,
      onPressed: null,
    ),
  ],
);

Future<void> _pumpField(
  WidgetTester tester,
  ThemeData theme,
  TextEditingController controller, {
  bool enabled = true,
}) => pumpSharedWidget(
  tester,
  theme,
  (context) => HbField(
    label: AppLocalizations.of(context).planNameLabel,
    controller: controller,
    enabled: enabled,
    errorText: enabled ? null : AppLocalizations.of(context).validationRequired,
  ),
);

Future<void> _pumpCode(
  WidgetTester tester,
  ThemeData theme,
  TextEditingController controller,
  ValueChanged<String> onCompleted,
) => pumpSharedWidget(
  tester,
  theme,
  (context) => HbCodeInput(
    label: AppLocalizations.of(context).verificationCode,
    controller: controller,
    onCompleted: onCompleted,
  ),
);
