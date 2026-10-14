import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/hb_nav_bar.dart';
import 'package:holdbuddy/core/widgets/hb_tab.dart';

import '../../support/load_inter_font.dart';

void main() {
  setUpAll(loadInterFont);
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    for (final tab in HbTab.values) {
      _testAppearance(theme, tab);
    }
  }
}

void _testAppearance(ThemeData theme, HbTab tab) {
  testWidgets('${theme.brightness} ${tab.name} matches the navbar design', (
    tester,
  ) async {
    final previous = debugDisableShadows;
    debugDisableShadows = false;
    try {
      await tester.pumpWidget(_preview(theme, tab));
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(const ValueKey('navbar_preview')),
        matchesGoldenFile(
          '../../goldens/nav_${theme.brightness.name}_${tab.name}.png',
        ),
      );
    } finally {
      debugDisableShadows = previous;
    }
  });
}

Widget _preview(ThemeData theme, HbTab tab) => MaterialApp(
  theme: theme,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: Center(
      child: RepaintBoundary(
        key: const ValueKey('navbar_preview'),
        child: ColoredBox(
          color: theme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(Tokens.space24),
            child: HbNavBar(selected: tab, onSelected: (_) {}),
          ),
        ),
      ),
    ),
  ),
);
