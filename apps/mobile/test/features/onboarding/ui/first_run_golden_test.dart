import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/router/app_route.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';

import '../../../support/load_inter_font.dart';
import '../../../support/pump_first_run.dart';

void main() {
  setUpAll(loadInterFont);
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    for (final route in [
      AppRoute.splash,
      AppRoute.onboardingContract,
      AppRoute.onboardingWitness,
      AppRoute.onboardingReturn,
      AppRoute.getStarted,
    ]) {
      _golden(theme, route);
      if (route != AppRoute.splash) _scaled(theme, route);
    }
  }
}

void _golden(ThemeData theme, AppRoute route) {
  testWidgets('${route.name} ${theme.brightness.name} matches first-run design', (
    tester,
  ) async {
    final previous = debugDisableShadows;
    debugDisableShadows = false;
    try {
      await pumpFirstRun(tester, theme, route);
      if (route != AppRoute.splash) await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('first_run_preview')),
        matchesGoldenFile(
          '../../../goldens/first_run_${route.name}_${theme.brightness.name}.png',
        ),
      );
    } finally {
      debugDisableShadows = previous;
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

void _scaled(ThemeData theme, AppRoute route) {
  testWidgets(
    '${route.name} ${theme.brightness.name} fits a small phone at 1.3x',
    (tester) async {
      await pumpFirstRun(
        tester,
        theme,
        route,
        width: 320,
        height: 640,
        textScale: 1.3,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      _expectTargets(tester);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}

void _expectTargets(WidgetTester tester) {
  for (final button in find.bySubtype<ButtonStyleButton>().evaluate()) {
    final size = tester.getSize(find.byWidget(button.widget));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
  }
}
