import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';

import '../../support/load_inter_font.dart';
import '../../support/pump_shared_widget.dart';
import '../../support/shared_controls_preview.dart';
import '../../support/shared_indicators_preview.dart';
import '../../support/shared_states_preview.dart';

void main() {
  setUpAll(loadInterFont);
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    _goldenTest(theme, 'controls', const SharedControlsPreview());
    _goldenTest(theme, 'indicators', const SharedIndicatorsPreview());
    _goldenTest(theme, 'states', const SharedStatesPreview());
    _scaledTest(theme, 'controls', const SharedControlsPreview());
    _scaledTest(theme, 'indicators', const SharedIndicatorsPreview());
    _scaledTest(theme, 'states', const SharedStatesPreview());
  }
}

void _goldenTest(ThemeData theme, String name, Widget child) {
  testWidgets(
    '${theme.brightness} $name shared components match source measurements',
    (tester) async {
      final previous = debugDisableShadows;
      debugDisableShadows = false;
      try {
        await pumpSharedWidget(
          tester,
          theme,
          (_) => child,
          textScale: 1,
          width: 390,
          height: 1400,
        );
        await _precacheFaces(tester);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byKey(const ValueKey('shared_preview')),
          matchesGoldenFile(
            '../../goldens/shared_${name}_${theme.brightness.name}.png',
          ),
        );
      } finally {
        debugDisableShadows = previous;
      }
    },
  );
}

Future<void> _precacheFaces(WidgetTester tester) async {
  final context = tester.element(find.byKey(const ValueKey('shared_preview')));
  await tester.runAsync(() async {
    for (final asset in ['profile', 'face_1', 'face_2', 'face_3']) {
      await precacheImage(AssetImage('assets/avatars/$asset.png'), context);
    }
  });
  await tester.pumpAndSettle();
}

void _scaledTest(ThemeData theme, String name, Widget child) {
  testWidgets('${theme.brightness} $name scales at 1.3 on a narrow phone', (
    tester,
  ) async {
    await pumpSharedWidget(tester, theme, (_) => child, height: 1400);
    expect(tester.takeException(), isNull);
  });
}
